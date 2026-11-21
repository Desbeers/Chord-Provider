//
//  SourceEditorSchemePreview.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//

import Adwaita
import CGtkSourceView

/// A preview of a single style scheme.
public struct EditorSchemePreview: AdwaitaWidget {

    /// The scheme.
    let scheme: Editor.Scheme
    /// Bool if the scheme is selected.
    let selected: Bool

    /// Init the widget.
    /// - Parameters:
    ///   - id: The scheme ID.
    ///   - selected: Bool if the scheme is selected.
    public init(scheme: Editor.Scheme, selected: Bool) {
        self.scheme = scheme
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
        let schemePointer = gtk_source_style_scheme_manager_get_scheme(manager, scheme.id)
        let preview = gtk_source_style_scheme_preview_new(schemePointer)
        // Use the description as the tooltip.
        gtk_widget_set_tooltip_text(preview, scheme.description)
        gtk_widget_add_css_class(preview, "scheme-preview")
        if scheme.id.starts(with: "Accent") {   // your scheme ID
            gtk_widget_add_css_class(preview, "scheme-accent-preview")
        }
        return ViewStorage(preview?.opaque())
    }

    /// Update the stored content.
    /// - Parameters:
    ///   - storage: The storage to update.
    ///   - data: Modify views before being updated.
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
