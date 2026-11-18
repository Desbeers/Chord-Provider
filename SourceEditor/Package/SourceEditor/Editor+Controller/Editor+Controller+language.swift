//

//  Editor+Controller+language.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//

import Foundation
import CGtkSourceView

extension Editor.Controller {

    // MARK: Language.

    /// The default manager, with the custom search path set exactly once.
    static let languageManager: OpaquePointer? = {
        guard let manager = gtk_source_language_manager_get_default() else { return nil }
        gtk_source_language_manager_append_search_path(manager, resourcesURL.path)
        return manager
    }()

    /// Get the default language.
    /// - Returns: `def.lang`
    func defaultLanguage() -> OpaquePointer? {
        guard let manager = Self.languageManager else { return nil }
        return gtk_source_language_manager_get_language(manager, "def")
    }

    /// Init the text highlighting language.
    /// - Parameters:
    ///   - buffer: The source buffer.
    ///   - language: The language for text highlighting.
    static func initLanguage(buffer: UnsafeMutablePointer<GtkSourceBuffer>?, language: Editor.Language) {
        let manager = Self.languageManager
        let languageID = gtk_source_language_manager_get_language(manager, language.languageName)
        gtk_source_buffer_set_language(buffer, languageID)
    }

    /// Set the language of the editor based on the file.
    /// - Parameter fileURL: The file that is opened in the editor.
    func setLanguage(fileURL: URL) {
        let manager = Self.languageManager
        // No guessed language means no highlighting
        let language = gtk_source_language_manager_guess_language(manager, fileURL.path, nil)
        gtk_source_buffer_set_language(buffer.sourceBufferPointer, language)
        bridge.language.wrappedValue = languageName
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

    // MARK: Debug and lookup.

    /// The display name of the `chordpro` language in the language manager.
    /// - Returns: The name, or `nil` if the language is not found.
    var chordProLookup: String? {
        let manager = Self.languageManager
        guard let language = gtk_source_language_manager_get_language(manager, "chordpro"),
              let name = gtk_source_language_get_name(language)
        else {
            return nil
        }
        return String(cString: name)
    }

    #if DEBUG

    /// Print all the search paths of the language manager.
    public static func printLanguageSearchPaths() {
        guard let manager = Self.languageManager,
              let paths = gtk_source_language_manager_get_search_path(manager)
        else {
            print("No language search paths")
            return
        }
        var index = 0
        while let path = paths[index] {
            print("Language search path \(index): \(String(cString: path))")
            index += 1
        }
    }

    /// Print the languages that the language manager does not know.
    static func printUnknownLanguages() {
        let manager = Editor.Controller.languageManager
        for language in Editor.Language.allCases where language != .unknown {
            if gtk_source_language_manager_get_language(manager, language.languageName) == nil {
                print("Language not found: \(language.languageName)")
            }
        }
    }

    #endif
}
