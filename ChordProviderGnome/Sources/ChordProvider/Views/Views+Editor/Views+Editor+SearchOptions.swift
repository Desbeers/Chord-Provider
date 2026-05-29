//
//  Views+Editor+SearchOptions.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension Views.Editor {

    /// The `View` with search options
    struct SearchOptions: View {
        /// Bool to show the search bar
        @Binding var showSearch: Bool
        /// The state of the application
        @Binding var appState: AppState
        /// The body of the `View`
        var view: Body {
            HStack(spacing: 5) { 
                SearchEntry()
                    .text($appState.editor.search.search)
                    .placeholderText("Search")
                    .nextMatch {
                        print("NEXT")
                    }
                Text("Replace")
                Entry("Replace", text: $appState.editor.search.replace)
                HStack {
                    Button(icon: .default(icon: .goUp)) {
                        appState.editor.command = .find(.previous)
                    }
                    Button(icon: .default(icon: .goDown)) {
                        appState.editor.command = .find(.next)
                    }
                }
                .style("linked")
                .insensitive(appState.editor.search.search.isEmpty)
                HStack {
                    Button("Replace") {
                        appState.editor.command = .replaceSearchMatch(with: appState.editor.search.replace)
                    }
                    .insensitive(appState.editor.search.replace.isEmpty || appState.editor.search.replace.isEmpty || !appState.editor.search.hasMatch)
                    Button("All") {
                        appState.editor.command = .replaceAllSearchMatches(with: appState.editor.search.replace)
                    }
                    .insensitive(appState.editor.search.replace.isEmpty || appState.editor.search.replace.isEmpty || !appState.editor.search.haveMatches)
                 }
                 .style("linked")
            }
            .padding(.horizontal)
            .padding(5, .bottom)
            .style(.caption)
        }
    }
}