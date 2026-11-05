//
//  SourceViewController+style.swift
//  SourceView
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import CAdw
import CGtkSourceView

extension SourceViewController {

    // MARK: Style.

    /// Init the editor style.
    /// - Parameters:
    ///   - view: The View storage.
    ///   - buffer: The text buffer.
    ///   - scheme: The scheme to use.
    static func initStyle(
        view: ViewStorage,
        buffer: ViewStorage,
        scheme: String
    ) {
        // This should always work
        if let url = Bundle.module.url(forResource: "SourceView+light", withExtension: "xml") {
            let manager = gtk_source_style_scheme_manager_get_default()
            gtk_source_style_scheme_manager_append_search_path(manager, url.deletingLastPathComponent().path)
        }
        // Set the style
        SourceViewController.updateStyle(
            view: view,
            buffer: buffer,
            scheme: scheme
        )
        // Add a *notification* for style changes
        buffer.notify(name: "dark", pointer: adw_style_manager_get_default()) {
            SourceViewController.updateStyle(
                view: view,
                buffer: buffer,
                scheme: scheme
            )
        }
    }

    /// Update the editor style.
    /// - Parameters:
    ///   - view: The View storage.
    ///   - buffer: The text buffer.
    ///   - scheme: The scheme to use.
    static func updateStyle(
        view: ViewStorage,
        buffer: ViewStorage,
        scheme: String
    ) {
        let isDark = adw_style_manager_get_dark(adw_style_manager_get_default()) == 1
        let gtkStyleManager = gtk_source_style_scheme_manager_get_default()

        // The scheme the user picked.
        let chosen = gtk_source_style_scheme_manager_get_scheme(gtkStyleManager, scheme)

        // Its partner for the current mode, if it has one.
        let key = isDark ? "dark-variant" : "light-variant"
        let partner = chosen
            .flatMap { gtk_source_style_scheme_get_metadata($0, key) }
            .flatMap { gtk_source_style_scheme_manager_get_scheme(gtkStyleManager, String(cString: $0)) }

        gtk_source_buffer_set_style_scheme(buffer.sourceBufferPointer, partner ?? chosen)
        setMarksStyle(view: view, darkMode: isDark)
    }

    /// Update the editor style.
    /// - Parameters:
    ///   - view: The View storage.
    ///   - buffer: The text buffer.
//     static func updateStyle(controller: SourceViewController) {
//         let adwStyleManager = adw_style_manager_get_default()
//         let isDark = adw_style_manager_get_dark(adwStyleManager)
//         let gtkStyleManager = gtk_source_style_scheme_manager_get_default()
//         if let scheme = gtk_source_style_scheme_manager_get_scheme(gtkStyleManager, controller.scheme.wrappedValue) {
//             for key in ["variant", "dark-variant", "light-variant"] {
//                 let value = gtk_source_style_scheme_get_metadata(scheme, key).map { String(cString: $0) }
//                 print(key, "=", value ?? "nil")
//             }
//             let wantedKey = isDark == 1 ? "dark-variant" : "light-variant"
//             let partner = gtk_source_style_scheme_get_metadata(scheme, wantedKey).map { String(cString: $0) }
//             print("wanted:", wantedKey, "->", partner ?? "nil")
//         }
//
//         //let theme = isDark == 1 ? "Adwaita-dark" : "Adwaita"
//         //let theme = theme == nil ? isDark == 1 ? "SourceView-dark" : "SourceView-light" : theme
//         let schemeID = controller.scheme.wrappedValue
//         let manager = gtk_source_style_scheme_manager_get_default()
//         let scheme = gtk_source_style_scheme_manager_get_scheme(manager, schemeID)
//         gtk_source_buffer_set_style_scheme(controller.buffer.sourceBufferPointer, scheme)
//         setMarksStyle(view: controller.view, darkMode: isDark == 1)
//     }
}
