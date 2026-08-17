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

    let controller: SourceViewController?

    var padding = 0
    var paddingEdges: Set<Edge> = []
    var lineNumbers = false
    var language: Language
    var wrapMode: WrapMode = .none
    var highlightCurrentLine: Bool = true
    var editable: Bool = true
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

    public func container<Data>(
        data: WidgetData,
        type: Data.Type
    ) -> ViewStorage {
        // Get the controller class
        let controller = controller ?? SourceViewController(bridge: $bridge, language: language)
        update(controller.view, data: data, updateProperties: true, type: type)
        // Return the GTKSourceView
        return controller.view
    }

    public func update<Data>(
        _ storage: ViewStorage,
        data: WidgetData,
        updateProperties: Bool,
        type: Data.Type
    ) {
        if updateProperties, let controller {
            let bridge = $bridge
            Idle {
                if controller.currentSearchText != bridge.search.search.wrappedValue {
                    controller.setSearchText(bridge.search.search.wrappedValue)
                }
                // Handle command
                if let command = bridge.wrappedValue.command {
                    controller.handle(command)
                    var newBridge = bridge.wrappedValue
                    newBridge.command = nil
                    bridge.wrappedValue = newBridge
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

    public func innerPadding(_ padding: Int = 10, edges: Set<Edge> = .all) -> Self {
        modify { sourceView in
            sourceView.padding = padding
            sourceView.paddingEdges = edges
        }
    }

    public func lineNumbers(_ lineNumbers: Bool = true) -> Self {
        modify { sourceView in
            sourceView.lineNumbers = lineNumbers
        }
    }

    public func editable(_ editable: Bool = true) -> Self {
        modify { sourceView in
            sourceView.editable = editable
        }
    }

    public func highlightCurrentLine(_ highlightCurrentLine: Bool = true) -> Self {
        modify { sourceView in
            sourceView.highlightCurrentLine = highlightCurrentLine
        }
    }

    public func wrapMode(_ wrapMode: WrapMode) -> Self {
        modify { sourceView in
            sourceView.wrapMode = wrapMode
        }
    }

    public func highlightSearchResult(_ highlightSearchResult: Bool) -> Self {
        modify { sourceView in
            sourceView.highlightSearchResult = highlightSearchResult
        }
    }
}
