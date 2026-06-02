//
//  SourceViewController+snippets.swift
//  GtkSourceView
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import CSourceView

extension SourceViewController {

    /// Add the *ChordPro* snippets path
    /// - Parameter path: The path to the snippet file as String
    ///
    /// - Note: The search path is an array, but only one path is needed here
    static func addSnippetsPath(_ path: String) {
        let manager = gtk_source_snippet_manager_get_default()
        // Set the search path
        path.withCString { cString in
            gtk_source_snippet_manager_set_search_path(
                manager,
                [cString, nil]
            )
        }
    }

    /// Load or unload snippets
    func handleSnippets() {
        snippetsAvailable = checkSnippetBrackets()
        if snippetsAvailable {
            if !snippetsLoaded {
                // Load the snippets
                gtk_source_completion_add_provider(completion, snippets?.opaque())
                snippetsLoaded = true
            }
        } else if snippetsLoaded {
            // Remove the snippets
            gtk_source_completion_remove_provider(completion, snippets?.opaque())
            snippetsLoaded = false
        }
    }

    /// Schedule the check for snippets
    func scheduleSnippetCheck() {
        if snippetsIdle != nil { return }
        snippetsIdle = Idle {
            self.snippetsIdle = nil
            self.handleSnippets()
        }
    }

    /// Check if the line starts with a `{` and does not contain a `}`
    /// - Returns: Bool if the snippets should be available
    func checkSnippetBrackets() -> Bool {
        var start = cursorPosition
        gtk_text_iter_set_line_offset(&start, 0)
        var end = start
        gtk_text_iter_forward_to_line_end(&end)
        guard let line = gtk_text_buffer_get_text(
            buffer.textBufferPointer,
            &start,
            &end,
            0
        ) else {
            return false
        }
        // Make sure the memory will be freed at the end
        defer {
            g_free(line)
        }
        let text = String(cString: line).trimmingCharacters(in: .whitespaces)
        return text.hasPrefix("{") && !text.contains("}")
    }
}
