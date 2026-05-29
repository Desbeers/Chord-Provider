//
//  SourceViewController+style.swift
//  GtkSourceView
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import CAdw
import CSourceView

extension SourceViewController {

    // MARK: Style

    static func initStyle(view: ViewStorage, buffer: ViewStorage, language: Language) {
        /// Set the language for text highlight
        SourceViewController.initLanguage(buffer: buffer, language: language)
        /// Set the style
        SourceViewController.updateStyle(view: view, buffer: buffer)
        /// Add a *notification* for style changes
        buffer.notify(name: "dark", pointer: adw_style_manager_get_default()) {
            SourceViewController.updateStyle(view: view, buffer: buffer)
        }
    }

    /// Update the style of the editor
    /// - Parameters:
    ///   - buffer: The text buffer
    ///   - styleManager: The `Adwaita` style manager
    static func updateStyle(view: ViewStorage, buffer: ViewStorage) {
        let styleManager = adw_style_manager_get_default()
        let isDark = adw_style_manager_get_dark(styleManager)
        let theme = isDark == 1 ? "Adwaita-dark" : "Adwaita"
        let manager = gtk_source_style_scheme_manager_get_default()
        let scheme = gtk_source_style_scheme_manager_get_scheme(manager, theme)
        gtk_source_buffer_set_style_scheme(buffer.sourceBufferPointer, scheme)
        setMarksStyle(view: view, darkMode: isDark == 1)
    }

    // MARK: Language

    static func initLanguage(buffer: ViewStorage, language: Language) {
        let manager = gtk_source_language_manager_get_default()
        if let urlPath = Bundle.module.url(forResource: "chordpro", withExtension: "lang") {
            let path = urlPath.deletingLastPathComponent().path()
            gtk_source_language_manager_append_search_path(manager, path)
            addSnippetsPath(path)
        }
        let lang = gtk_source_language_manager_get_language(manager, language.languageName)
        gtk_source_buffer_set_language(buffer.sourceBufferPointer, lang)
    }
}
