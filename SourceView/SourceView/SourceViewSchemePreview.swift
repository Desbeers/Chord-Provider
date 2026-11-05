//
//  SourceViewSchemePreview.swift
//  SourceView
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import CAdw
import CGtkSourceView

/// A preview of a single style scheme.
public struct SourceViewSchemePreview: AdwaitaWidget {

    /// The scheme ID.
    let id: String
    /// Bool if the scheme is selected.
    let selected: Bool
    /// Init the widget.
    public init(id: String, selected: Bool) {
        self.id = id
        self.selected = selected
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
        let manager = gtk_source_style_scheme_manager_get_default()
        let scheme = gtk_source_style_scheme_manager_get_scheme(manager, id)
        return ViewStorage(gtk_source_style_scheme_preview_new(scheme).opaque())
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
        gtk_source_style_scheme_preview_set_selected(storage.opaquePointer, selected ? 1 : 0)
    }
}
