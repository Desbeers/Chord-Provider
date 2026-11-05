//
//  SourceViewMap.swift
//  SourceView
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import CAdw
import CGtkSourceView

/// A mini-map for the editor.
public struct SourceViewMap: AdwaitaWidget {

    /// The controller.
    var controller: SourceViewController

    /// Init the widget.
    public init(
        controller: SourceViewController
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
        gtk_source_map_set_view(view.opaquePointer?.cast(), controller.view.sourceViewPointer)
        return view
    }
}
