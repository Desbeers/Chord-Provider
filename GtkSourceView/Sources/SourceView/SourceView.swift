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
    @Binding var text: String
    /// The padding between the border and the content.
    var padding = 0
    /// The edges affected by the padding.
    var paddingEdges: Set<Edge> = []
    /// Whether the line numbers are visible.
    var numbers = false
    /// The programming language for syntax highlighting.
    var language: Language = .plain
    /// The (word) wrap mode used when rendering the text.
    var wrapMode: WrapMode = .none
    /// Bool if the current line should be highlighted
    var highlightCurrentLine: Bool = true
    /// Bool if the text is editable
    var editable: Bool = true

    /// Initialize a code editor.
    /// - Parameter text: The editor's content.
    public init(text: Binding<String>) {
        self._text = text
    }

    /// Get the editor's view storage.
    /// - Parameters:
    ///     - data: The widget data.
    ///     - type: The view render data type.
    /// - Returns: The view storage.
    public func container<Data>(data: WidgetData, type: Data.Type) -> ViewStorage {
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
        /// - Note: Important, or else the popup fill fail. This took me a long time to find-out...
        gtk_source_init()
        update(editor, data: data, updateProperties: true, type: type)
        return editor
    }

    /// Update a view storage to the editor.
    /// - Parameters:
    ///     - storage: The view storage.
    ///     - data: The widget data.
    ///     - updateProperties: Whether to update the view's properties.
    ///     - type: The view render data type.
    public func update<Data>(_ storage: ViewStorage, data: WidgetData, updateProperties: Bool, type: Data.Type) {
        if let buffer = storage.content["buffer"]?.first {
            buffer.connectSignal(name: "changed") {
                let text = getText(buffer: buffer)
                if self.text != text {
                    self.text = text
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
            if updateProperties {
                if getText(buffer: buffer) != self.text {
                    gtk_text_buffer_set_text(buffer.opaquePointer?.cast(), text, -1)
                }
            }
        }
        if updateProperties {
            if paddingEdges.contains(.top) {
                gtk_text_view_set_top_margin(storage.opaquePointer?.cast(), padding.cInt)
            }
            if paddingEdges.contains(.bottom) {
                gtk_text_view_set_bottom_margin(storage.opaquePointer?.cast(), padding.cInt)
            }
            if paddingEdges.contains(.leading) {
                gtk_text_view_set_left_margin(storage.opaquePointer?.cast(), padding.cInt)
            }
            if paddingEdges.contains(.trailing) {
                gtk_text_view_set_right_margin(storage.opaquePointer?.cast(), padding.cInt)
            }
            gtk_text_view_set_editable(storage.opaquePointer?.cast(), editable.cBool)
            gtk_source_view_set_show_line_numbers(storage.opaquePointer?.cast(), numbers.cBool)
            gtk_text_view_set_wrap_mode(storage.opaquePointer?.cast(), wrapMode.rawValue)
            gtk_source_view_set_highlight_current_line(storage.opaquePointer?.cast(), highlightCurrentLine.cBool)
        }
    }

    /// Get the text view's content.
    /// - Parameter buffer: The text view's buffer.
    /// - Returns: The content.
    func getText(buffer: ViewStorage) -> String {
        let startIter: UnsafeMutablePointer<GtkTextIter> = .allocate(capacity: 1)
        let endIter: UnsafeMutablePointer<GtkTextIter> = .allocate(capacity: 1)
        gtk_text_buffer_get_start_iter(buffer.opaquePointer?.cast(), startIter)
        gtk_text_buffer_get_end_iter(buffer.opaquePointer?.cast(), endIter)
        return .init(
            cString: gtk_text_buffer_get_text(buffer.opaquePointer?.cast(), startIter, endIter, true.cBool)
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
        newSelf.padding = padding
        newSelf.paddingEdges = edges
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
