//
//  SourceView.swift
//  ChordProviderEditor
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore
import CGtkSourceView

/// A text or code editor widget.
public struct SourceView: AdwaitaWidget {

    /// The editor bridge
    @Binding var bridge: SourceViewBridge
    /// The editor controller
    let controller: SourceViewController?
    /// Padding of the editor
    var padding = 0
    /// The padding edges
    var paddingEdges: Set<Edge> = []
    /// Bool to show the line numbers
    var lineNumbers = false
    /// The language for text highlighting
    var language: Language
    /// The text wrapmode
    var wrapMode: WrapMode = .none
    /// Bool to highlight the current line
    var highlightCurrentLine: Bool = true
    /// Bool if the text is editable
    var editable: Bool = true
    /// Bool to highlight the search rsults
    var highlightSearchResult: Bool = false
    /// Init the editor
    public init(
        bridge: Binding<SourceViewBridge>,
        controller: SourceViewController?,
        language: Language
    ) {
        self._bridge = bridge
        self.language = language
        self.controller = controller
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
        let sourceController = controller ?? SourceViewController(bridge: $bridge, language: language)
        update(sourceController.view, data: data, updateProperties: true, type: type)
        // Return the GTKSourceView
        return sourceController.view
    }

    /// Update the stored content.
    /// - Parameters:
    ///   - storage: The storage to update.
    ///   - sdata: Modify views before being updated
    ///   - supdateProperties: Whether to update the view's properties.
    ///   - stype: The view render data type.
    public func update<Data>(
        _ storage: ViewStorage,
        data: WidgetData,
        updateProperties: Bool,
        type: Data.Type
    ) {
        if updateProperties, let controller {
            let editor = $bridge
            Idle {
                if controller.currentSearchText != editor.search.search.wrappedValue {
                    controller.setSearchText(editor.search.search.wrappedValue)
                }
                // Handle command
                if let command = editor.wrappedValue.command {
                    controller.handle(command)
                    var newBridge = editor.wrappedValue
                    newBridge.command = nil
                    editor.wrappedValue = newBridge
                }
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
                gtk_text_view_set_editable(storage.textViewPointer, editable.cBool)
                gtk_source_view_set_show_line_numbers(storage.sourceViewPointer, lineNumbers.cBool)
                gtk_text_view_set_wrap_mode(storage.textViewPointer, wrapMode.rawValue)
                gtk_source_view_set_highlight_current_line(storage.sourceViewPointer, highlightCurrentLine.cBool)

                gtk_source_search_context_set_highlight(
                    controller.searchContext.opaquePointer,
                    highlightSearchResult ? 1 : 0
                )
            }
            storage.previousState = self
        }
    }

    // MARK: View modifiers

    /// Set the inner padding
    public func innerPadding(_ padding: Int = 10, edges: Set<Edge> = .all) -> Self {
        modify { sourceView in
            sourceView.padding = padding
            sourceView.paddingEdges = edges
        }
    }

    /// Show the line numbers
    public func lineNumbers(_ lineNumbers: Bool = true) -> Self {
        modify { sourceView in
            sourceView.lineNumbers = lineNumbers
        }
    }

    /// Set the text as editable
    public func editable(_ editable: Bool = true) -> Self {
        modify { sourceView in
            sourceView.editable = editable
        }
    }

    /// Highlight the current line
    public func highlightCurrentLine(_ highlightCurrentLine: Bool = true) -> Self {
        modify { sourceView in
            sourceView.highlightCurrentLine = highlightCurrentLine
        }
    }

    /// Set the wrap mode
    public func wrapMode(_ wrapMode: WrapMode) -> Self {
        modify { sourceView in
            sourceView.wrapMode = wrapMode
        }
    }

    /// Highlight the search results
    public func highlightSearchResult(_ highlightSearchResult: Bool) -> Self {
        modify { sourceView in
            sourceView.highlightSearchResult = highlightSearchResult
        }
    }
}
