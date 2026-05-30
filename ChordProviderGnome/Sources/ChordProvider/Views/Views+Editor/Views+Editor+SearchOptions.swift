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
        /// The state of the application
        @Binding var appState: AppState
        /// Bool to show the options
        @State private var showOptions: Bool = false
        /// The body of the `View`
        var view: Body {
            SearchBar()
                .searchModeEnabled(appState.scene.showSearchBar)
                .showCloseButton()
                .child {
                    VStack {
                        HStack(spacing: 5) {
                            Symbol(icon: .default(icon: .systemSearch))
                            Entry("Search", text: $appState.editor.search.search)
                                .focus(appState.scene.focusSearch)
                            // SearchEntry()
                            //     .text($appState.editor.search.search)
                            //     .placeholderText("Search")
                            //     .nextMatch {
                            //         print("NEXT")
                            //     }
                            HStack {
                                Button(icon: .default(icon: .goUp)) {
                                    appState.editor.command = .search(.previous)
                                }
                                Button(icon: .default(icon: .goDown)) {
                                    appState.editor.command = .search(.next)
                                }
                            }
                            .style("linked")
                            .insensitive(appState.editor.search.search.isEmpty)
                            Toggle(icon: .default(icon: .editFindReplace), isOn: $appState.editor.search.showReplaceOptions)
                            options
                        }
                        if appState.editor.search.showReplaceOptions {
                            replace
                                .padding(5, .top)
                                .transition(.crossfade)
                        }
                    }
                    .padding(.horizontal)
                    .padding(5, .bottom)
                    .style(.caption)
                    .halign(.start)
                    .hexpand()
                }
        }

        var replace: AnyView {            
            HStack(spacing: 5) {
                Symbol(icon: .default(icon: .editFindReplace))
                Entry("Replace", text: $appState.editor.search.replace)
                // SearchEntry()
                //     .text($appState.editor.search.replace)
                //     .placeholderText("Replace")
                //     .nextMatch {
                //         print("NEXT")
                //     }
                HStack {
                    Button("Replace") {
                        appState.editor.command = .replaceSearchMatch(with: appState.editor.search.replace)
                    }
                    .insensitive(appState.editor.search.replace.isEmpty || appState.editor.search.replace.isEmpty || !appState.editor.search.hasMatch)
                    Button("Replace All") {
                        appState.editor.command = .replaceAllSearchMatches(with: appState.editor.search.replace)
                    }
                    .insensitive(appState.editor.search.replace.isEmpty || appState.editor.search.replace.isEmpty || !appState.editor.search.haveMatches)
                }
                .style("linked")
            }
        }

        var options: AnyView {
            Toggle(icon: .default(icon: .applicationsSystem), isOn: $showOptions)
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
        }
    }
}
