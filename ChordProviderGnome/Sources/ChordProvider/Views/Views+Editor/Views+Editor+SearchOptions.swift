//
//  Views+Editor+SearchOptions.swift
//  ChordProvider
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension Views.Editor {

    /// The `View` with search options
    struct SearchOptions: View {
        /// The state of the application
        @Binding var appState: AppState
        /// Bool to show the options
        @State private var showOptions: Bool = false
        /// The body of the `View`
        var view: Body {
            Views.Empty()
                .topToolbar(visible: appState.scene.showSearchBar) {
                    search
                }
        }
        /// The search `View`
        var search: AnyView { 
            VStack {
                HStack(spacing: 5) {
                    Symbol(icon: .default(icon: .systemSearch))
                    Entry("Search", text: $appState.editor.search.search)
                        .focus(appState.scene.focusSearch)
                        .warning(appState.editor.search.noMatches)
                    HStack {
                        Button(icon: .default(icon: .goUp)) {
                            appState.editor.command = .search(.previous)
                        }
                        .keyboardShortcut("g".shift().ctrl(), active: appState.scene.showSearchBar)
                        .tooltip("Previous")
                        Button(icon: .default(icon: .goDown)) {
                            appState.editor.command = .search(.next)
                        }
                        .keyboardShortcut("g".ctrl(), active: appState.scene.showSearchBar)
                        .tooltip("Next")
                    }
                    .style("linked")
                    .insensitive(appState.editor.search.noMatches)
                    // Below should be a toggle but I can't attach
                    // keyboard shortcuts to them
                    Button(icon: .default(icon: .editFindReplace)) {
                        appState.editor.search.showReplaceOptions.toggle()
                        switch appState.editor.search.showReplaceOptions {
                            case true:
                                appState.scene.focusReplace.signal()
                            case false:
                                appState.scene.focusSearch.signal()
                        }
                    }
                    .keyboardShortcut("h".ctrl(), active: appState.scene.showSearchBar)
                    .flat(!appState.editor.search.showReplaceOptions)
                    Text(appState.editor.search.countDisplay)
                    Text("")
                        .hexpand()
                    options
                    Button(icon: .default(icon: .windowClose)) {
                        appState.scene.showSearchBar = false
                    }
                    .flat()
                    .circular()
                    .tooltip("Close")
                }
                if appState.editor.search.showReplaceOptions {
                    replace
                        .padding(5, .top)
                        .transition(.crossfade)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
            .style(.caption)
            .hexpand()
        }
        /// The replace `View`
        var replace: AnyView {            
            HStack(spacing: 5) {
                Symbol(icon: .default(icon: .editFindReplace))
                Entry("Replace", text: $appState.editor.search.replace)
                    .focus(appState.scene.focusReplace)
                HStack {
                    Button("Replace") {
                        appState.editor.command = .replaceSearchMatch(with: appState.editor.search.replace)
                    }
                    .insensitive(appState.editor.search.replace.isEmpty || !appState.editor.search.hasMatch)
                    Button("Replace All") {
                        appState.editor.command = .replaceAllSearchMatches(with: appState.editor.search.replace)
                    }
                    .insensitive(appState.editor.search.replace.isEmpty || !appState.editor.search.haveMatches)
                }
                .style("linked")
                .insensitive(appState.editor.search.search == appState.editor.search.replace)
            }
        }
        /// The options `View`
        var options: AnyView {
            Toggle(icon: .default(icon: .applicationsSystem), isOn: $showOptions)
                .flat()
                .popover(visible: $showOptions) {
                    VStack {
                        Toggle("Match Whole Word Only", isOn: $appState.editor.search.matchWholeWordOnly.onSet{ state in
                                appState.editor.command = .matchWholeWordOnly(state)
                            }
                        )
                        .checkButton()
                        Toggle("Case Sensitive", isOn: $appState.editor.search.caseSensitive.onSet{ state in
                                appState.editor.command = .caseSensitive(state)
                            }
                        )
                        .checkButton()
                        Toggle("Regular Expessions", isOn: $appState.editor.search.regularExpressions.onSet{ state in
                                appState.editor.command = .regularExpressions(state)
                            }
                        )
                        .checkButton()
                    }
                }
                .tooltip("Options")
        }
    }
}
