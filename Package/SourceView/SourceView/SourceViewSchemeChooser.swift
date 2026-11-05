//
//  SourceViewSchemeChooser.swift
//  SourceView
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import CGtkSourceView

/// A button to select a scheme for the editor.
public struct SourceViewSchemeChooser: AdwaitaWidget {

    /// The `GtkSourceView` controller.
    let controller: SourceViewController

    /// Init the widget
    public init(controller: SourceViewController) {
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
        // Set the chooser to the current scheme.
        let manager = gtk_source_style_scheme_manager_get_default()
        let schemeID = controller.scheme.wrappedValue
        if let scheme = gtk_source_style_scheme_manager_get_scheme(manager, schemeID) {
            gtk_source_style_scheme_chooser_set_style_scheme(controller.schemeChooser.opaquePointer, scheme)
        }
        //gtk_button_set_label(controller.schemeChooser.opaquePointer?.cast(), "Theme")
        // Return the Scheme Chooser Button that is already created by the controller.
        return controller.schemeChooser
    }
}
