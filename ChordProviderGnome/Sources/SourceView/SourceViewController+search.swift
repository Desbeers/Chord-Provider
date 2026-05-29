//
//  SourceViewController+search.swift
//  GtkSourceView
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import CSourceView
import ChordProviderCore

extension SourceViewController {

    // struct SearchState {
    //     /// Current search position
    //     var currentIter = GtkTextIter()
    //     /// Current match start
    //     var matchStart = GtkTextIter()
    //     /// Current match end
    //     var matchEnd = GtkTextIter()
    //     /// True when a match is active
    //     var hasMatch = false
    //     /// True when there are matches
    //     var haveMatches = false
    // }

    public enum SearchDirection {
        case next
        case previous
    }

    func getBridge() -> Binding<SourceViewBridge>? { 
        guard let bridge = view.fields["bridge"] as? Binding<SourceViewBridge> else { return nil }
        return bridge
    }

    /// Set highlight of seach text
    func searchHighlight(_ highlight: Bool) {
        gtk_source_search_context_set_highlight(
            searchContext.opaquePointer,
            highlight ? 1 : 0
        )
    }

    /// Reset the search position
    func resetSearchPosition() {
        guard let bridge = getBridge() else { return }
        bridge.search.hasMatch.wrappedValue = false
        gtk_text_buffer_get_start_iter(
            buffer.textBufferPointer,
            &bridge.search.currentIter.wrappedValue
        )
    }

    var currentSearchText: String {
        guard let text = gtk_source_search_settings_get_search_text(
            searchSettings.opaquePointer?.cast()
        ) else {
            return ""
        }
        return String(cString: text)
    }

    func find(direction: SearchDirection) {
        guard let bridge = getBridge() else { return }
        var start = GtkTextIter()
        var end = GtkTextIter()
        var wrapped: gboolean = 0
        var found: gboolean = 0
        switch direction {
        case .next:
            _ = gtk_text_iter_forward_char(&bridge.search.currentIter.wrappedValue)
            found = gtk_source_search_context_forward(
                searchContext.opaquePointer,
                &bridge.search.currentIter.wrappedValue,
                &start,
                &end,
                &wrapped
            )
        case .previous:
            _ = gtk_text_iter_backward_char(&bridge.search.currentIter.wrappedValue)
            found = gtk_source_search_context_backward(
                searchContext.opaquePointer,
                &bridge.search.currentIter.wrappedValue,
                &start,
                &end,
                &wrapped
            )
        }
        guard found != 0 else {
            bridge.search.hasMatch.wrappedValue = false
            return
        }
        bridge.search.hasMatch.wrappedValue = true
        bridge.search.currentIter.wrappedValue = direction == .next ? end : start
        bridge.search.matchStart.wrappedValue = start
        bridge.search.matchEnd.wrappedValue = end
        gtk_text_buffer_select_range(
            buffer.textBufferPointer,
            &bridge.search.matchStart.wrappedValue,
            &bridge.search.matchEnd.wrappedValue
        )
        scrollToCursor()
        bridge.search.hasMatch.wrappedValue = true
        bridge.search.haveMatches.wrappedValue = true
    }

    func haveSearchOccurrences() {
        guard let bridge = getBridge() else { return }
        let count = gtk_source_search_context_get_occurrences_count(
            searchContext.opaquePointer
        )
        bridge.search.haveMatches.wrappedValue = count > 0 ? true : false
    }

    func replaceAllSearchMatches(with replacement: String) {
        guard 
            let bridge = getBridge(),
            bridge.search.haveMatches.wrappedValue else {
            return
        }
        gtk_source_search_context_replace_all(
            searchContext.opaquePointer,
            replacement,
            -1,
            nil
        )
        bridge.search.hasMatch.wrappedValue = false
        bridge.search.haveMatches.wrappedValue = false
    }
    
    func replaceSearchMatch(with replacement: String) {
        guard 
            let bridge = getBridge(),
            bridge.search.hasMatch.wrappedValue else {
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
        bridge.search.hasMatch.wrappedValue = false
        haveSearchOccurrences()
    }
}
