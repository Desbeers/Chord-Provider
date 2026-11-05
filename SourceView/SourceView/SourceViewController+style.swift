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
    func initStyle() {
        // This should always work
        if let url = Bundle.module.url(forResource: "SourceView+light", withExtension: "xml") {
            let manager = gtk_source_style_scheme_manager_get_default()
            gtk_source_style_scheme_manager_append_search_path(manager, url.deletingLastPathComponent().path)
        }
        // Set the style
        updateStyle()
        // Add a *notification* for style changes
        buffer.notify(name: "dark", pointer: adw_style_manager_get_default()) {
            self.scheme.wrappedValue = self.modeSchemeID()
            // self.updateStyle()
        }
    }

    /// Update the editor style.
    func updateStyle() {
        let gtkStyleManager = gtk_source_style_scheme_manager_get_default()
        let style = gtk_source_style_scheme_manager_get_scheme(gtkStyleManager, scheme.wrappedValue)
        gtk_source_buffer_set_style_scheme(buffer.sourceBufferPointer, style)
        setMarksStyle()
    }

    /// The scheme IDs that fit the current appearance.
    /// - Returns: The scheme IDs.
    static var schemeIDs: [String] {
        let dark = SourceViewController.darkMode
        let manager = gtk_source_style_scheme_manager_get_default()
        var result: [String] = []
        guard let ids = gtk_source_style_scheme_manager_get_scheme_ids(manager) else {
            return result
        }
        var index = 0
        while let id = ids[index] {
            let name = String(cString: id)
            index += 1
            guard let scheme = gtk_source_style_scheme_manager_get_scheme(manager, name) else { continue }
            let variant = gtk_source_style_scheme_get_metadata(scheme, "variant").map { String(cString: $0) }
            if (variant == "dark") == dark {
                result.append(name)
            }
        }
        return result
    }

    /// The ID of the scheme that is actually applied to the buffer.
    func activeSchemeID() -> String? {
        gtk_source_buffer_get_style_scheme(buffer.sourceBufferPointer)
            .flatMap { gtk_source_style_scheme_get_id($0) }
            .map { String(cString: $0) }
    }

    /// The scheme ID that fits the current mode.
    /// - Returns: The partner ID for the mode, or `id` itself if it has none.
    func modeSchemeID() -> String {
        let id = scheme.wrappedValue
        let manager = gtk_source_style_scheme_manager_get_default()
        guard let scheme = gtk_source_style_scheme_manager_get_scheme(manager, id) else {
            return id
        }
        let key = SourceViewController.darkMode ? "dark-variant" : "light-variant"
        guard let partner = gtk_source_style_scheme_get_metadata(scheme, key).map({ String(cString: $0) }),
              gtk_source_style_scheme_manager_get_scheme(manager, partner) != nil
        else { return id }
        return partner
    }

    /// Bool if the current style is dark.
    static var darkMode: Bool {
        adw_style_manager_get_dark(adw_style_manager_get_default()) == 1
    }
}
