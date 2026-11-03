//
//  SourceView.swift
//  SourceView
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import CGtkSourceView

/// A text or code editor widget.
public struct SourceView: AdwaitaWidget {

    /// The editor controller
    let controller: SourceViewController
    /// Padding of the editor
    var padding = 0
    /// The padding edges
    var paddingEdges: Set<Edge> = []
    /// Bool to show the line numbers
    var lineNumbers = false
    /// The text wrapmode
    var wrapMode: WrapMode = .none
    /// Bool to highlight the current line
    var highlightCurrentLine: Bool = true
    /// Bool if the text is editable
    var editable: Bool = true

    /// The language
    var language: Language = .plain
    /// The resources directory for the language
    var languageResources: URL?

    /// Init the editor
    public init(
        bridge: Binding<SourceViewBridge>,
        controller: SourceViewController
    ) {
        self.controller = controller
        self.controller.view.fields["bridge"] = bridge
    }

    /// The view storage.
    /// - Parameters:
    ///   - data: The widget data.
    ///   - type: The view render data type.
    /// - Returns: The view storage.
    public func container<Data>(
        data: WidgetData,
        type: Data.Type
    ) -> ViewStorage {
        // Get the controller class
        let sourceController = controller
        update(sourceController.view, data: data, updateProperties: true, type: type)
        // Return the GTKSourceView
        return sourceController.view
    }

    /// Update the stored content.
    /// - Parameters:
    ///   - storage: The storage to update.
    ///   - data: Modify views before being updated
    ///   - updateProperties: Whether to update the view's properties.
    ///   - type: The view render data type.
    public func update<Data>(
        _ storage: ViewStorage,
        data: WidgetData,
        updateProperties: Bool,
        type: Data.Type
    ) {
        if updateProperties {
            guard let editor = self.controller.bridgeBinding else {
                return
            }
            if
                (storage.previousState as? Self)?.language != language ||
                (storage.previousState as? Self)?.languageResources != languageResources {
                let language = SourceViewController.initLanguage(
                    buffer: controller.buffer,
                    language: language,
                    resources: languageResources
                )
                Idle {
                    editor.language.wrappedValue = language
                }
            }
            if (storage.previousState as? Self)?.padding != padding {
                if paddingEdges.contains(.top) {
                    gtk_text_view_set_top_margin(storage.textViewPointer, padding.cInt)
                }
                if paddingEdges.contains(.bottom) {
                    gtk_text_view_set_bottom_margin(storage.textViewPointer, padding.cInt)
                }
                if paddingEdges.contains(.leading) {
                    gtk_text_view_set_left_margin(storage.textViewPointer, padding.cInt)
                }
                if paddingEdges.contains(.trailing) {
                    gtk_text_view_set_right_margin(storage.textViewPointer, padding.cInt)
                }
            }
            if (storage.previousState as? Self)?.editable != editable {
                gtk_text_view_set_editable(storage.textViewPointer, editable.cBool)
            }
            if (storage.previousState as? Self)?.lineNumbers != lineNumbers {
                gtk_source_view_set_show_line_numbers(storage.sourceViewPointer, lineNumbers.cBool)
            }
            if (storage.previousState as? Self)?.wrapMode != wrapMode {
                gtk_text_view_set_wrap_mode(storage.textViewPointer, wrapMode.gtkValue)
            }
            if (storage.previousState as? Self)?.highlightCurrentLine != highlightCurrentLine {
                gtk_source_view_set_highlight_current_line(storage.sourceViewPointer, highlightCurrentLine.cBool)
            }
            Idle {
                if controller.currentSearchText != editor.search.search.wrappedValue {
                    controller.setSearchText(editor.search.search.wrappedValue)
                }
                // Handle command
                if let command = editor.wrappedValue.command {
                    controller.handle(command)
                    editor.wrappedValue.command = nil
                }
                gtk_source_search_context_set_highlight(
                    controller.searchContext.opaquePointer,
                    editor.showSearchBar.wrappedValue.cBool
                )
            }
            storage.previousState = self
        }
    }

    // MARK: View modifiers

    /// Set the language for the editor.
    /// - Parameter language: The ``Language``
    /// - Returns: self.
    public func language(_ language: Language) -> Self {
        modify { sourceView in
            sourceView.language = language
        }
    }

    /// Set the resources directory for a language.
    /// - Parameter url: The URL to the resources.
    /// - Returns: Self.
    public func languageResources(_ url: URL?) -> Self {
        if let url {
            return modify { sourceView in
                sourceView.languageResources = url
            }
        }
        return self
    }

    /// The closure when the text has changed.
    /// - Parameter closure: The closure to run.
    /// - Returns: Self.
    public func onTextChanged(_ closure: @escaping (String) -> [SourceMark]) -> Self {
        modify { sourceView in
            sourceView.controller.onTextChanged = closure
        }
    }

    /// The closure when the line has changed.
    /// - Parameter closure: The closure to run.
    /// - Returns: Self.
    public func onLineChanged(_ closure: @escaping () -> Void) -> Self {
        modify { sourceView in
            sourceView.controller.onLineChanged = closure
        }
    }

    /// The closure when a line is tripple clicked.
    /// - Parameter closure: The closure to run.
    /// - Returns: Self.
    public func onTripleClick(_ closure: @escaping () -> Void) -> Self {
        modify { sourceView in
            sourceView.controller.onTripleClick = closure
        }
    }

    /// Set the inner padding of the editor
    /// - Parameters:
    ///   - padding: The padding.
    ///   - edges: The edges for the padding.
    /// - Returns: Self.
    public func innerPadding(_ padding: Int = 10, edges: Set<Edge> = .all) -> Self {
        modify { sourceView in
            sourceView.padding = padding
            sourceView.paddingEdges = edges
        }
    }

    /// Show the line numbers in the editor.
    /// - Parameter lineNumbers: Bool to show the line numbers.
    /// - Returns: Self.
    public func lineNumbers(_ lineNumbers: Bool = true) -> Self {
        modify { sourceView in
            sourceView.lineNumbers = lineNumbers
        }
    }

    /// Set the text as editable.
    /// - Parameter editable: Bool to make the text editable
    /// - Returns: Self.
    public func editable(_ editable: Bool = true) -> Self {
        modify { sourceView in
            sourceView.editable = editable
        }
    }

    /// Highlight the current line
    /// - Parameter highlightCurrentLine: Bool to highlight the current line.
    /// - Returns: Self.
    public func highlightCurrentLine(_ highlightCurrentLine: Bool = true) -> Self {
        modify { sourceView in
            sourceView.highlightCurrentLine = highlightCurrentLine
        }
    }

    /// Set the wrap mode.
    /// - Parameter wrapMode: The wrap mode of the text.
    /// - Returns: Self.
    public func wrapMode(_ wrapMode: WrapMode) -> Self {
        modify { sourceView in
            sourceView.wrapMode = wrapMode
        }
    }
}
