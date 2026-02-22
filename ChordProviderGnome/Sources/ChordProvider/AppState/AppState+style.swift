//
//  AppState+style.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import CAdw

extension AppState {
    
    /// Set the style for the application
    mutating func setStyle() {
        adw_style_manager_set_color_scheme(self.styleManager, self.settings.theme.appearance.colorScheme)
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

        css.withCString { cssCString in
            gtk_css_provider_load_from_string(cssProvider, cssCString)
        }
    }
}
