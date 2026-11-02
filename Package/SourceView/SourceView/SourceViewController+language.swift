//
//  SourceViewController+language.swift
//  ChordProviderEditor
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
    ///   - Resources: Optional language definition and snippets.
    static func initLanguage(buffer: ViewStorage, language: Language, resources: URL?) {
        let manager = gtk_source_language_manager_get_default()
        if let resources {
            let path = resources.path()
            gtk_source_language_manager_append_search_path(manager, path)
            addSnippetsPath(path)
        }
        let lang = gtk_source_language_manager_get_language(manager, language.languageName)
        gtk_source_buffer_set_language(buffer.sourceBufferPointer, lang)
    }
}
