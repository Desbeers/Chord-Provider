//
//  Editor+Controller+file.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import CGtkSourceView

// MARK: File handling
//
// The file handlers have callbacks that can be set in the Controller.
//
// There are still 'completion' callbacks in this file, but not
// publicly settable. I leave them here for now.

extension Editor.Controller {

    /// The location of the current file, if it has one.
    ///
    /// This is called several times in this file and that looks
    /// not so efficient; however, I want to keep this logic in
    /// one place to keep it readable for myself.
    ///
    /// The function is *not* public. The fileURL should be updated in the
    /// ``Editor.Bridge`` Binding, the only information the UI should see.
    ///
    /// Marked as *Private* so I know for sure no other file fiddles with this :-)
    private var fileURL: URL? {
        guard
            let location = gtk_source_file_get_location(file),
            let path = g_file_get_path(location)
        else {
            return nil
        }
        defer {
            // Free the newly allocated string
            g_free(path)
        }
        return URL(fileURLWithPath: String(cString: path))
    }

    /// Mark the file in the buffer as unmodified.
    func markAsUnmodified() {
        gtk_text_buffer_set_modified(buffer.textBufferPointer, 0)
    }

    /// File *user data* class for `C` callbacks.
    ///
    /// The GTK async functions (`*_async`) are `C` functions, and `C` has no closures.
    /// To get Swift state into the callback, the call takes a `user_data` pointer that
    /// is handed back, untouched, when the operation is done. This class is that state.
    ///
    /// The round trip:
    /// 1. `Unmanaged.passRetained(fileData).toOpaque()` turns this object into a raw
    ///    pointer and adds a +1 retain, so it stays alive while `C` holds it.
    /// 2. The `C` callback runs later, on the main thread, with that pointer as `data`.
    ///    It cannot capture anything from the surrounding Swift scope; everything it
    ///    needs has to arrive through `data`.
    /// 3. `Unmanaged<FileData>.fromOpaque(data).takeRetainedValue()` gets the object
    ///    back and balances the +1 from step 1.
    /// 4. The callback calls the matching `*_finish` function, which reports success as
    ///    a `gboolean` (`Int32`, so compare with `!= 0`) and writes a `GError` into an
    ///    out-parameter on failure.
    /// 5. ``finish(_:_:)`` hands the result to the completion handler.
    ///
    /// - Note: Ownership:
    ///   - `passRetained` / `takeRetainedValue` keep this object alive while C holds it.
    ///   - `g_object_ref` / `g_object_unref` do the same for the GTK loader or saver.
    ///   - `GError` is owned by us after `*_finish` and is freed in `finish` with `g_clear_error`.
    @MainActor
    private final class FileData {

        /// The completion handler.
        let completion: (Result<Void, Error>) -> Void
        /// The file object.
        let object: gpointer
        /// Init the file data.
        init(object: gpointer, completion: @escaping  (Result<Void, Error>) -> Void) {
            self.object = object
            self.completion = completion
            _ = g_object_ref(object)
        }
        /// Deinit the file data.
        isolated deinit { g_object_unref(object) }
        /// Execute the completion handler.
        func finish(_ ok: Bool, _ error: UnsafeMutablePointer<GError>?) {
            var error = error
            if ok {
                completion(.success(()))
            } else {
                let message = error.map { String(cString: $0.pointee.message) } ?? "Unknown error"
                g_clear_error(&error)
                completion(.failure(SourceEditorError.failed(message)))
            }
        }
    }

    /// Create a new file.
    /// - Parameter text: The initial text.
    func new(_ text: String) {
        guard let textBuffer = buffer.textBufferPointer else {
            return
        }
        // Replace the GtkSourceFile, so the new document has no URL
        // and no encoding or newline type left over from the previous file.
        g_object_unref(file?.cast())
        file = gtk_source_file_new()
        // This will clear the *undo* buffer as well.
        gtk_text_buffer_set_text(textBuffer, text, -1)
        // Mark as unmodified.
        markAsUnmodified()
        // Cursor at the start, not after the inserted text.
        moveCursorToFirstLine()
        // Clear the file URL in the bridge.
        bridge.fileURL.wrappedValue = nil
        // Callback
        onNew?()
    }

    /// Open an existing file.
    /// - Parameters:
    ///   - url: The URL to open.
    ///   - completion: The completion handler.
    func open(
        _ url: URL,
        completion: @escaping  (Result<Void, Error>) -> Void = { _ in }
    ) {
        let notify: @MainActor (Result<Void, Error>) -> Void = { [weak self] result in
            if let self {
                onOpen?(result.flatMap { _ -> Result<URL, Error> in
                    guard url == fileURL else {
                        return .failure(SourceEditorError.noURL)
                    }
                    return .success(url)
                })
            }
            completion(result)
        }
        let gfile = g_file_new_for_path(url.path)
        gtk_source_file_set_location(file, gfile)

        // Publish the new URL; the location is set synchronously above.
        bridge.fileURL.wrappedValue = fileURL

        let loader = gtk_source_file_loader_new(buffer.sourceBufferPointer, file)

        defer {
            // Release our own references. `file` keeps its own ref to the location,
            // and `fileData` below keeps its own ref to the loader.
            g_object_unref(loader?.cast())
            g_object_unref(gfile?.cast())
        }

        let fileData = FileData(
            object: UnsafeMutableRawPointer(loader.unsafelyUnwrapped),
            completion: notify
        )
        // Start the load. See ``FileData`` for how the callback and `user_data` work.
        gtk_source_file_loader_load_async(
            // pointer
            loader,
            // priority
            G_PRIORITY_DEFAULT,
            // cancellable: not used; the load can not be cancelled.
            nil,
            // progress_callback: not used.
            nil,
            // progress_callback_data: not used.
            nil,
            // progress_callback_notify: not used.
            nil,
            // callback
            { source, result, data in
                guard let data else {
                    return
                }
                let context = Unmanaged<FileData>.fromOpaque(data).takeRetainedValue()
                var error: UnsafeMutablePointer<GError>?
                let ok = gtk_source_file_loader_load_finish(OpaquePointer(source), result, &error) != 0
                MainActor.assumeIsolated { context.finish(ok, error) }
            },
            // user_data
            Unmanaged.passRetained(fileData).toOpaque()
        )
    }

    /// Check the file URL.
    /// - Throws: SourceEditorError.
    func checkFileURL(_ url: URL?) throws(SourceEditorError) {
        guard let url else {
            if gtk_source_file_get_location(file) == nil {
                throw .noURL
            }
            return
        }
        gtk_source_file_check_file_on_disk(file)
        if gtk_source_file_is_deleted(file) != 0 {
            throw .fileDeleted(url)
        }
        if gtk_source_file_is_externally_modified(file) != 0 {
            throw .externallyModified(url)
        }
    }

    /// Save the buffer text.
    /// - Parameters:
    ///   - url: The URL to save; only for a 'Save As...'.
    ///   - completion: The completion handler.
    func save(
        to url: URL? = nil,
        completion: @escaping (Result<Void, Error>) -> Void = { _ in }
    ) {
        // Resulting notification.
        let notify: @MainActor (Result<Void, Error>) -> Void = { [weak self] result in
            if let self {
                onSave?(result.flatMap { _ -> Result<URL, Error> in
                    guard let fileURL else {
                        return .failure(SourceEditorError.noURL)
                    }
                    bridge.fileURL.wrappedValue = fileURL
                    return .success(fileURL)
                })
            }
            completion(result)
        }

        // Only a plain save needs the on-disk check; Save As writes to a new target.
        if url == nil {
            do {
                try checkFileURL(fileURL)
            } catch {
                notify(.failure(error))
                return
            }
        }

        let saver: OpaquePointer
        let target: OpaquePointer?
        if let url {
            target = g_file_new_for_path(url.path)
            saver = gtk_source_file_saver_new_with_target(buffer.sourceBufferPointer, file, target)
        } else {
            target = nil
            saver = gtk_source_file_saver_new(buffer.sourceBufferPointer, file)
        }
        defer {
            g_object_unref(UnsafeMutableRawPointer(saver))
            if let target { g_object_unref(UnsafeMutableRawPointer(target)) }
        }

        let fileData = FileData(
            object: UnsafeMutableRawPointer(saver),
            completion: notify
        )
        // Start the save. See ``FileData`` for how the callback and `user_data` work.
        gtk_source_file_saver_save_async(
            // pointer
            saver,
            // priority
            G_PRIORITY_DEFAULT,
            // cancellable: not used; the save can not be cancelled.
            nil,
            // progress_callback: not used.
            nil,
            // progress_callback_data: not used.
            nil,
            // progress_callback_notify: not used.
            nil,
            // callback
            { source, result, data in
                guard let data else {
                    return
                }
                let context = Unmanaged<FileData>.fromOpaque(data).takeRetainedValue()
                var error: UnsafeMutablePointer<GError>?
                let ok = gtk_source_file_saver_save_finish(OpaquePointer(source), result, &error) != 0
                MainActor.assumeIsolated { context.finish(ok, error) }
            },
            // user_data
            Unmanaged.passRetained(fileData).toOpaque()
        )
    }
}

extension MenuButton {

    /// Enable a Menu Button.
    /// - Parameters:
    ///   - enabled: Bool if enabled.
    ///   - label: The label of the Menu Button.
    /// - Returns: AnyView.
    ///
    /// This should be part of `adwaita-swift` but I have bigger fish to fry at the moment :-)
    ///
    /// Will do later!
    public func enabled(_ enabled: Bool, _ label: String) -> AnyView {
        var filteredLabel: String { label.filter { $0.isLetter || $0.isNumber || $0 == "-" || $0 == "." } }
        return wrapModifier(properties: [enabled]) { _ in
            guard
                let app = g_application_get_default(),
                let window = gtk_application_get_active_window(app.cast()),
                let action = g_action_map_lookup_action(window.opaque(), filteredLabel)
            else {
                return
            }
            g_simple_action_set_enabled(action, enabled ? 1 : 0)
        }
    }
}
