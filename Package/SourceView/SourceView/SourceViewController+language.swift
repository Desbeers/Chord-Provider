//
//  SourceViewController+language.swift
//  SourceView
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import CAdw
import CGtkSourceView

extension SourceViewController {

    // MARK: Language.

    /// Init the text highlighting language.
    /// - Parameters:
    ///   - buffer: The text buffer.
    ///   - language: The language for text highlighting.
    ///   - snippets: Optional snippets directory.
    static func initLanguage(buffer: ViewStorage, language: Language, snippets: URL?) {
        let manager = gtk_source_language_manager_get_default()
        gtk_source_language_manager_append_search_path(manager, SourceViewController.resourcesURL.path)
        if let snippets {
            SourceViewController.addSnippetsPath(snippets.path())
        }
        let languageID = gtk_source_language_manager_get_language(manager, language.languageName)
        gtk_source_buffer_set_language(buffer.sourceBufferPointer, languageID)
    }

    /// Set the language of the editor based on the file.
    /// - Parameter fileURL: The file that is opened in the editor.
    func setLanguage(fileURL: URL) {
        guard let bridge = bridgeBinding else {
            return
        }
        let manager = gtk_source_language_manager_get_default()
        guard let language = gtk_source_language_manager_guess_language(
            manager,
            fileURL.path,
            nil
        ) else {
            gtk_source_buffer_set_language(buffer.sourceBufferPointer, nil)
            bridge.language.wrappedValue = nil
            return
        }
        gtk_source_buffer_set_language(buffer.sourceBufferPointer, language)
        bridge.language.wrappedValue = String(cString: gtk_source_language_get_name(language))
    }

    /// The display name of the current language in the editor.
    var languageName: String? {
        guard let language = gtk_source_buffer_get_language(buffer.sourceBufferPointer),
              let name = gtk_source_language_get_name(language)
        else {
            return nil
        }
        return String(cString: name)
    }
}
