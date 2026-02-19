//
//  AppState+style.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import CAdw

extension AppState {
    
    /// Set the style for the application
    mutating func setStyle() {
        let isDark = adw_style_manager_get_dark(styleManager) == 1 ? true : false
        let css = Markup.css(
            theme: self.settings.theme,
            dark: isDark
        )
        addCssFromString(css)
    }
    
    /// Set the style for the application from a CSS string
    /// - Parameter css: The CSS string
    mutating private func addCssFromString(_ css: String?) {
        guard let css else { return }

        /// Remove old provider if it exists
        if let provider = currentCssProvider {
            if let display = gdk_display_get_default() {
                gtk_style_context_remove_provider_for_display(
                    display,
                    provider.opaque()
                )
            }
            g_object_unref(provider)
            currentCssProvider = nil
        }

        /// Create new provider
        let provider = gtk_css_provider_new()

        css.withCString { cssCString in
            gtk_css_provider_load_from_string(provider, cssCString)
        }

        /// Attach to default display
        if let display = gdk_display_get_default() {
            gtk_style_context_add_provider_for_display(
                display,
                provider?.opaque(),
                guint(GTK_STYLE_PROVIDER_PRIORITY_APPLICATION)
            )
        }

        /// Keep provider for next call
        currentCssProvider = provider
    }
}
