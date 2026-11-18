//
//  EditorMap.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//

import Adwaita
import CGtkSourceView

/// A mini-map for the content in the editor.
public struct EditorMap: AdwaitaWidget {

    /// The controller.
    let controller: Editor.Controller

    /// Init the widget.
    /// - Parameter controller: The controller of the editor this map belongs to.
    public init(
        controller: Editor.Controller
    ) {
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
        let view = ViewStorage(gtk_source_map_new().opaque())
        gtk_source_map_set_view(view.opaquePointer?.cast(), controller.view.sourceEditorPointer)
        return view
    }
}
