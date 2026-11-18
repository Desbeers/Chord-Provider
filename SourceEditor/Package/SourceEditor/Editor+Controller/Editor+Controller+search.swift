//

//  Editor+Controller+search.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//

import Adwaita
import CGtkSourceView

extension Editor.Controller {

    // MARK: Setters

    /// Set the search text.
    /// - Parameter text: The text to search for.
    func setSearchText(_ text: String) {
        gtk_source_search_settings_set_search_text(
            searchSettings.searchSettingsPointer,
            text
        )
        bridge.search.currentMatchIndex.wrappedValue = 0
        clearSelection()
    }

    /// Set the index of the current match.
    /// - Note: This will be 0 when there is no match selected.
    func setCurrentMatchIndex() {
        var cursor = cursorPosition
        var currentMatchStart = bridge.search.matchStart.wrappedValue
        guard gtk_text_iter_equal(&cursor, &currentMatchStart) != 0 else {
            // The selection is gone, reset the match index
            bridge.search.currentMatchIndex.wrappedValue = 0
            return
        }

        var start = bufferRange.start
        var matchStart = GtkTextIter()
        var matchEnd = GtkTextIter()
        var wrapped: gboolean = 0
        var index = 0

        while gtk_source_search_context_forward(
            searchContext.opaquePointer,
            &start,
            &matchStart,
            &matchEnd,
            &wrapped
        ) != 0, wrapped == 0 {
            index += 1
            if gtk_text_iter_equal(&matchStart, &currentMatchStart) != 0 {
                bridge.search.currentMatchIndex.wrappedValue = index
                return
            }
            if gtk_text_iter_equal(&matchStart, &matchEnd) != 0 {
                start = matchEnd
                gtk_text_iter_forward_char(&start)
            } else {
                start = matchEnd
            }
        }
        bridge.search.currentMatchIndex.wrappedValue = 0
    }

    // MARK: Getters

    /// The current search text.
    var currentSearchText: String {
        guard let text = gtk_source_search_settings_get_search_text(
            searchSettings.searchSettingsPointer
        ) else {
            return ""
        }
        return String(cString: text)
    }

    /// The current count of matches.
    func matchesCount() {
        Idle { [self] in
            let count = gtk_source_search_context_get_occurrences_count(
                searchContext.opaquePointer
            )
            bridge.search.matchesCount.wrappedValue = Int(count)
        }
    }

    // MARK: Search and replace

    /// Search for a text.
    /// - Parameter direction: Search backwards or forwards.
    func search(direction: Editor.Bridge.SearchDirection) {
        var selectionRange = selectedRange ?? (cursorPosition, cursorPosition)
        var bridgeValues = bridge.wrappedValue
        defer {
            bridge.wrappedValue = bridgeValues
        }
        var start = GtkTextIter()
        var end = GtkTextIter()
        var wrapped: gboolean = 0
        let found: gboolean
        switch direction {
        case .next:
            found = gtk_source_search_context_forward(
                searchContext.opaquePointer,
                &selectionRange.end,
                &start,
                &end,
                &wrapped
            )
        case .previous:
            found = gtk_source_search_context_backward(
                searchContext.opaquePointer,
                &selectionRange.start,
                &start,
                &end,
                &wrapped
            )
        }
        guard found != 0 else {
            bridgeValues.search.matchStart = bridgeValues.search.matchEnd
            return
        }
        bridgeValues.search.matchStart = start
        bridgeValues.search.matchEnd = end
        gtk_text_buffer_select_range(
            buffer.textBufferPointer,
            &start,
            &end
        )
        scrollToCursor()
    }

    /// Replace a match.
    /// - Parameter replacement: The replacement text.
    func replaceSearchMatch(with replacement: String) {
        guard bridge.wrappedValue.search.hasMatch else {
            return
        }

        var start = bridge.search.matchStart.wrappedValue
        var end = bridge.search.matchEnd.wrappedValue

        gtk_source_search_context_replace(
            searchContext.opaquePointer,
            &start,
            &end,
            replacement,
            -1,
            nil
        )
        search(direction: .next)
    }

    /// Replace all matches.
    /// - Parameter replacement: The replacement text.
    func replaceAllSearchMatches(with replacement: String) {
        guard bridge.search.matchesCount.wrappedValue > 0 else {
            return
        }
        gtk_source_search_context_replace_all(
            searchContext.opaquePointer,
            replacement,
            -1,
            nil
        )
        resetMatchPosition()
    }

    // MARK: Search options

    /// Set regular expressions option to search text.
    func regularExpressions(_ enabled: Bool) {
        gtk_source_search_settings_set_regex_enabled(
            searchSettings.searchSettingsPointer,
            enabled ? 1 : 0
        )
    }

    /// Set match whole word only option to search text.
    func matchWholeWordOnly(_ enabled: Bool) {
        gtk_source_search_settings_set_at_word_boundaries(
            searchSettings.searchSettingsPointer,
            enabled ? 1 : 0
        )
    }

    /// Set case sensitive option to search text.
    func caseSensitive(_ enabled: Bool) {
        gtk_source_search_settings_set_case_sensitive(
            searchSettings.searchSettingsPointer,
            enabled ? 1 : 0
        )
    }

    // MARK: Helpers

    /// Reset the search.
    /// - Note: Used when opening new content.
    func resetSearch() {
        bridge.search.wrappedValue = Editor.Bridge.Search()
        resetMatchPosition()
    }

    /// Reset the position of the current match to the start of the buffer.
    private func resetMatchPosition() {
        let start = bufferRange.start
        bridge.search.matchStart.wrappedValue = start
        bridge.search.matchEnd.wrappedValue = start
    }
}
