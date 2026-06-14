//
//  SourceView.swift
//  GTKSourceView
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
    var numbers = false
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
        /// Get the controller class
        let controller = controller ?? SourceViewController(bridge: $bridge, language: language)
        update(controller.view, data: data, updateProperties: true, type: type)
        /// Return the GTKSourceView
        return controller.view
    }

    public func update<Data>(
        _ storage: ViewStorage,
        data: WidgetData,
        updateProperties: Bool,
        type: Data.Type
    ) {
        if
            updateProperties, let controller {
            let bridge = $bridge
            Idle {
               if controller.currentSearchText != bridge.search.search.wrappedValue {
                    controller.setSearchText(bridge.search.search.wrappedValue)
                }
                /// Handle command
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
                gtk_source_view_set_show_line_numbers(storage.sourceViewPointer, numbers.cBool)
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
        var newSelf = self
        newSelf.padding = padding
        newSelf.paddingEdges = edges
        return newSelf
    }

    public func lineNumbers(_ visible: Bool = true) -> Self {
        var newSelf = self
        newSelf.numbers = visible
        return newSelf
    }

    public func editable(_ editable: Bool = true) -> Self {
        var newSelf = self
        newSelf.editable = editable
        return newSelf
    }

    public func highlightCurrentLine(_ highlight: Bool = true) -> Self {
        var newSelf = self
        newSelf.highlightCurrentLine = highlight
        return newSelf
    }

    public func wrapMode(_ mode: WrapMode) -> Self {
        var newSelf = self
        newSelf.wrapMode = mode
        return newSelf
    }

    public func highlightSearchResult(_ highlight: Bool) -> Self {
        var newSelf = self
        newSelf.highlightSearchResult = highlight
        return newSelf
    }
}
