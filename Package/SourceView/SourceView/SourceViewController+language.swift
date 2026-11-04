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
    ///   - resources: Optional language definition and snippets.
    static func initLanguage(buffer: ViewStorage, language: Language, resources: URL?) -> String? {
        let manager = gtk_source_language_manager_get_default()
        if let resources {
            let path = resources.path()
            gtk_source_language_manager_append_search_path(manager, path)
            addSnippetsPath(path)
        }
        let languageID = gtk_source_language_manager_get_language(manager, language.languageName)
        gtk_source_buffer_set_language(buffer.sourceBufferPointer, languageID)
        if let languageID {
            return String(cString: gtk_source_language_get_name(languageID))
        }
        return nil
    }

    /// Set the language of the editor based on the file.
    /// - Parameter fileURL: The file that is opened in the editor.
    public func setLanguage(fileURL: URL) {
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

//         if let ids = gtk_source_language_manager_get_language_ids(manager) {
//             var index = 0
//
//             while let id = ids[index] {
//                 print(String(cString: id))
//                 index += 1
//             }
//         }

    }
}
