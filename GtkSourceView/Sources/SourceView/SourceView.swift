//
//  SourceView.swift
//  GTKSourceView
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import CCodeEditor

/// A text or code editor widget.
public struct SourceView: AdwaitaWidget {

    /// The editor's content.
    @BindingProperty(
        observe: { _, text, storage in
            if let buffer = storage.content["buffer"]?.first {
                buffer.connectSignal(name: "changed") {
                    let currentText = Self.getText(buffer: buffer)
                    if text.wrappedValue != currentText {
                        text.wrappedValue = currentText
                    }
                    if let snippets = storage.fields["snippets"] as? UnsafeMutablePointer<GtkSourceCompletionSnippets>?, let provider = storage.fields["provider"] as? Bool {
                        let completion = gtk_source_view_get_completion(storage.opaquePointer?.cast())
                        let bracket = bracket_condition_met(storage.opaquePointer?.cast())
                        switch bracket {
                        case 1:
                            /// We have a bracket on the line
                            if provider {
                                /// There is already a provider for **ChordPro** directive snippets
                                break
                            } else {
                                /// Add the provider with **ChordPro** snippets
                                gtk_source_completion_add_provider(completion, snippets?.opaque())
                                storage.fields["provider"] = true
                            }
                        default:
                            /// Remove the provider
                            storage.fields["provider"] = false
                            gtk_source_completion_hide(completion);
                            gtk_source_completion_remove_provider(completion, snippets?.opaque())
                        }
                    }
                }
            }
        },
        set: { _, text, storage in
            if let buffer = storage.content["buffer"]?.first, Self.getText(buffer: buffer) != text {
                gtk_text_buffer_set_text(buffer.opaquePointer?.cast(), text, -1)
            }
        },
        pointer: Any.self
    )
    var text: Binding<String> = .constant("")
    /// The padding between the border and the content.
    @Property(
        set: { $1.set($0) },
        pointer: OpaquePointer.self
    )
    var padding: InnerPadding?
    /// Whether the line numbers are visible.
    @Property(
        set: { gtk_source_view_set_show_line_numbers($0.cast(), $1.cBool) },
        pointer: OpaquePointer.self
    )
    var numbers = false
    /// The programming language for syntax highlighting.
    var language: Language = .plain
    /// The (word) wrap mode used when rendering the text.
    @Property(
        set: { gtk_text_view_set_wrap_mode($0.cast(), $1.rawValue) },
        pointer: OpaquePointer.self
    )
    var wrapMode: WrapMode = .none
    /// Bool if the current line should be highlighted
    @Property(
        set: { gtk_source_view_set_highlight_current_line($0.cast(), $1.cBool) },
        pointer: OpaquePointer.self
    )
    var highlightCurrentLine: Bool = true
    /// Bool if the text is editable
    @Property(
        set: { gtk_text_view_set_editable($0.cast(), $1.cBool) },
        pointer: OpaquePointer.self
    )
    var editable: Bool = true

    /// Initialize a code editor.
    /// - Parameter text: The editor's content.
    public init(text: Binding<String>) {
        self.text = text
    }

    /// The inner padding of a text view.
    struct InnerPadding {

        /// The padding.
        var padding: Int
        /// The affected edges.
        var paddingEdges: Set<Edge>

        /// Set the inner padding on a text view.
        /// - Parameter pointer: The text view.
        func set(_ pointer: OpaquePointer) {
            if paddingEdges.contains(.top) {
                gtk_text_view_set_top_margin(pointer.cast(), padding.cInt)
            }
            if paddingEdges.contains(.bottom) {
                gtk_text_view_set_bottom_margin(pointer.cast(), padding.cInt)
            }
            if paddingEdges.contains(.leading) {
                gtk_text_view_set_left_margin(pointer.cast(), padding.cInt)
            }
            if paddingEdges.contains(.trailing) {
                gtk_text_view_set_right_margin(pointer.cast(), padding.cInt)
            }
        }

    }

    /// Get the editor's view storage.
    /// - Parameters:
    ///     - data: The widget data.
    ///     - type: The view render data type.
    /// - Returns: The view storage.
    public func container<Data>(data: WidgetData, type: Data.Type) -> ViewStorage where Data: ViewRenderData {
        let buffer = ViewStorage(gtk_source_buffer_new(nil)?.opaque())
        let editor = ViewStorage(
            gtk_source_view_new_with_buffer(buffer.opaquePointer?.cast())?.opaque(),
            content: ["buffer": [buffer]]
        )
        /// Set the **ChordPro** `directive` snippets
        editor.fields["snippets"] = gtk_source_completion_snippets_new()
        /// Don't show them by default; `snippets` are *fuzzy* but I want them only for directives
        editor.fields["provider"] = false
        /// Magic, not my code :-)
        codeeditor_buffer_set_theme_adaptive(buffer.opaquePointer?.cast())
        /// Add **ChordPro** stuff to the editor
        setLanguage(buffer: buffer)
        /// Init the source editor
        /// - Note: Important, or else the popup will fail. This took me a long time to find-out...
        gtk_source_init()
        initProperties(editor, data: data, type: type)
        update(editor, data: data, updateProperties: true, type: type)
        return editor
    }

    /// Get the text view's content.
    /// - Parameter buffer: The text view's buffer.
    /// - Returns: The content.
    static func getText(buffer: ViewStorage) -> String {
        let startIter = UnsafeMutablePointer<GtkTextIter>.allocate(capacity: 1)
        let endIter   = UnsafeMutablePointer<GtkTextIter>.allocate(capacity: 1)
        defer {
            startIter.deallocate()
            endIter.deallocate()
        }

        gtk_text_buffer_get_start_iter(buffer.opaquePointer?.cast(), startIter)
        gtk_text_buffer_get_end_iter(buffer.opaquePointer?.cast(), endIter)

        return String(
            cString: gtk_text_buffer_get_text(
                buffer.opaquePointer?.cast(),
                startIter,
                endIter,
                true.cBool
            )
        )
    }

    /// Get the text view's programming language.
    /// - Parameter buffer: The text view's buffer.
    func setLanguage(buffer: ViewStorage) {
        let manager = gtk_source_language_manager_get_default()
        if let urlPath = Bundle.module.url(forResource: "chordpro", withExtension: "lang") {
            let path = urlPath.deletingLastPathComponent().path()
            /// Add the **ChordPro** language
            gtk_source_language_manager_append_search_path(manager, path)
            /// Add the **ChordPro** snippets
            /// - Note: Doing this in `Swift` gives crashes on Linux; so I use a `C` function
            path.withCString { cString in
                codeeditor_snippets(cString)
            }
        }
        let language = gtk_source_language_manager_get_language(manager, language.languageName)
        gtk_source_buffer_set_language(buffer.opaquePointer?.cast(), language)
    }

    /// Add padding between the editor's content and border.
    /// - Parameters:
    ///     - padding: The padding's value.
    ///     - edges: The affected edges.
    /// - Returns: The editor.
    public func innerPadding(_ padding: Int = 10, edges: Set<Edge> = .all) -> Self {
        var newSelf = self
        newSelf.padding = .init(padding: padding, paddingEdges: edges)
        return newSelf
    }

    /// Set the visibility of line numbers.
    /// - Parameter visible: Whether the numbers are visible.
    /// - Returns: The editor.
    public func lineNumbers(_ visible: Bool = true) -> Self {
        var newSelf = self
        newSelf.numbers = visible
        return newSelf
    }

    /// Make the text read-only.
    /// - Parameter readOnly: Whether the text is read-only
    /// - Returns: The editor.
    public func editable(_ editable: Bool = true) -> Self {
        var newSelf = self
        newSelf.editable = editable
        return newSelf
    }

    /// Highlight the current line.
    /// - Parameter highlight: Whether the current line is highlighted
    /// - Returns: The editor.
    public func highlightCurrentLine(_ highlight: Bool = true) -> Self {
        var newSelf = self
        newSelf.highlightCurrentLine = highlight
        return newSelf
    }

    /// Set the syntax highlighting programming language.
    /// - Parameter language: The programming language.
    /// - Returns: The editor.
    public func language(_ language: Language) -> Self {
        var newSelf = self
        newSelf.language = language
        return newSelf
    }

    /// Set the wrapMode for the text view.
    ///
    /// Available wrap modes are `none`, `char`, `word`, `wordChar`. Please refer to the
    /// corresponding `GtkWrapMode` documentation for the details on how they work.
    ///
    /// - Parameter mode: The `WrapMode` to set.
    public func wrapMode(_ mode: WrapMode) -> Self {
        var newSelf = self
        newSelf.wrapMode = mode
        return newSelf
    }
}
