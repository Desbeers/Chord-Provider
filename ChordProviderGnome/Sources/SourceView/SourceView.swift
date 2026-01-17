//
//  SourceView.swift
//  GTKSourceView
//
//  © 2025 Nick Berendsen
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
        update(controller.storage, data: data, updateProperties: true, type: type)
        /// Return the GTKSourceView
        return controller.storage
    }

    public func update<Data>(
        _ storage: ViewStorage,
        data: WidgetData,
        updateProperties: Bool,
        type: Data.Type
    ) {
        if
            updateProperties, let controller {
            let bridgeBinding = $bridge
            Idle {
                /// Handle command (one-shot)
                if let command = bridgeBinding.wrappedValue.command {
                    controller.handle(command)
                    var newBridge = bridgeBinding.wrappedValue
                    newBridge.command = nil
                    bridgeBinding.wrappedValue = newBridge
                }
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
            storage.previousState = self
        } else {
            print("ERROR")
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
}
