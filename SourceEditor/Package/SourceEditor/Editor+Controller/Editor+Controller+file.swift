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
    /// The function is *not* public. The fileURL shpuld be updated in the
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
        defer { g_free(path) }
        return URL(fileURLWithPath: String(cString: path))
    }

    /// Mark the file in the buffer as unmodified.
    func markAsUnmodified() {
        gtk_text_buffer_set_modified(buffer.textBufferPointer, 0)
    }

    /// Keeps a GObject alive for the duration of an async GIO call, then releases it.
    /// Created and consumed on the GTK main thread only.
    @MainActor
    private final class CallContext {
        let completion:  (Result<Void, Error>) -> Void
        let object: gpointer

        init(object: gpointer, completion: @escaping  (Result<Void, Error>) -> Void) {
            self.object = object
            self.completion = completion
            _ = g_object_ref(object)
        }
        isolated deinit { g_object_unref(object) }

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
    func new(_ text: String = "") {
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

        /// Clear the file URL in the bridge.
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
                self.onOpen?(result.flatMap { _ -> Result<URL, Error> in
                    guard let url = self.fileURL else {
                        return .failure(SourceEditorError.noURL)
                    }
                    return .success(url)
                })
            }
            completion(result)
        }
        let gfile = g_file_new_for_path(url.path)
        defer {
            g_object_unref(gfile?.cast())
            bridge.fileURL.wrappedValue = fileURL
        }
        gtk_source_file_set_location(file, gfile)
        let loader = gtk_source_file_loader_new(buffer.sourceBufferPointer, file)
        defer { g_object_unref(loader?.cast()) }

        let ctx = CallContext(
            object: UnsafeMutableRawPointer(loader.unsafelyUnwrapped),
            completion: notify
        )
        gtk_source_file_loader_load_async(
            loader, G_PRIORITY_DEFAULT, nil,
            nil, nil, nil,
            { source, result, data in
                let ctx = Unmanaged<CallContext>.fromOpaque(data!).takeRetainedValue()
                var error: UnsafeMutablePointer<GError>?
                let ok = gtk_source_file_loader_load_finish(OpaquePointer(source), result, &error) != 0
                let err = error
                MainActor.assumeIsolated { ctx.finish(ok, err) }
            },
            Unmanaged.passRetained(ctx).toOpaque()
        )
    }

    /// Save the buffer text.
    /// - Parameters:
    ///   - url: The URL to save; only for a 'Save As...'.
    ///   - completion: The completion handler.
    func save(
        to url: URL? = nil,
        completion:  @escaping (Result<Void, Error>) -> Void = { _ in }
    ) {
        let notify: @MainActor (Result<Void, Error>) -> Void = { [weak self] result in
            if let self {
                self.onSave?(result.flatMap { _ -> Result<URL, Error> in
                    guard let url = self.fileURL else {
                        return .failure(SourceEditorError.noURL)
                    }
                    return .success(url)
                })
            }
            completion(result)
        }
        if url == nil, gtk_source_file_get_location(file) == nil {
            notify(.failure(SourceEditorError.noURL))
            return
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
            bridge.fileURL.wrappedValue = fileURL
        }

        let ctx = CallContext(
            object: UnsafeMutableRawPointer(saver),
            completion: notify
        )
        gtk_source_file_saver_save_async(
            saver, G_PRIORITY_DEFAULT, nil,
            nil, nil, nil,
            { source, result, data in
                let ctx = Unmanaged<CallContext>.fromOpaque(data!).takeRetainedValue()
                var error: UnsafeMutablePointer<GError>?
                let ok = gtk_source_file_saver_save_finish(OpaquePointer(source), result, &error) != 0
                let err = error
                MainActor.assumeIsolated { ctx.finish(ok, err) }
            },
            Unmanaged.passRetained(ctx).toOpaque()
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
    /// This should be part of `adwaita-swift` but I have bigger fish to fride at the moment :-)
    ///
    /// Will do later!
    public func enabled(_ enabled: Bool, _ label: String) -> AnyView {
        var filteredLabel: String { label.filter { $0.isLetter || $0.isNumber || $0 == "-" || $0 == "." } }
        return wrapModifier(properties: [enabled]) { storage in
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
