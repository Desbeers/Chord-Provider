//
//  Views+Toolbar.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension Views {

    /// Toolbar Views
    enum Toolbar {
        // Just a placeholder
    }
}

extension Views.Toolbar {

    /// The  toolbar for the Main `View`
    struct Main: View {
        /// The `AdwaitaApp`
        var app: AdwaitaApp
        /// The `AdwaitaWindow`
        var window: AdwaitaWindow
        /// The state of the application
        @Binding var appState: AppState
        /// The list of recent songs
        @Binding var recentSongs: RecentSongs
        /// The body of the `View`
        var view: Body {
            /// Bool if the song is transposed
            let transposed = Binding(
                get: {
                    appState.editor.song.transposing != 0
                },
                set: {
                    /// Needed but unused
                    _ = $0
                }
            )
            HeaderBar {
                HStack(spacing: 5) {
                    Toggle(
                        icon: .default(icon: .textEditor),
                        isOn: $appState.settings.editor.showEditor
                    )
                    .tooltip("Show the editor")
                    ToggleButton(
                        icon: .default(icon: .objectFlipVertical),
                        isOn: transposed
                    ) {
                        appState.scene.showTransposeDialog = true
                    }
                    .tooltip(appState.editor.song.transposeTooltip)
                    DropDown(
                        selection: $appState.settings.app.instrumentID.onSet { _ in
                            appState.updateDatabase(main: true)
                        },
                        values: appState.settings.app.instruments,
                        id: \.id,
                        description: \.description
                    )
                    .tooltip(appState.currentInstrument.status)
                    /// Make sure that it updates labels by giving it an unique ID
                    .id(appState.settings.app.instruments)
                    /// Disable selection when an `Instrument` is modified in the `Database View`
                    .insensitive(appState.currentInstrument.modified)
                    //
                    Toggle(
                        icon: .default(icon: .viewDual),
                        isOn: $appState.settings.app.columnPaging
                    )
                    .tooltip("Show the song in columns")
                }
            }
            end: {
                HStack(spacing: 5) {
                    /// Show optional tags
                    if let tags = appState.editor.song.metadata.tags {
                        Views.Tags(tags: tags)
                    }
                    Toggle(
                        icon: .default(icon: .helpAbout),
                        isOn: $appState.scene.showDebugDialog
                    )
                    .tooltip("See how your song is parsed")
                    Menu(icon: .default(icon: .openMenu)) {
                        MenuButton("Open") {
                            /// Reset MIDI stuff
                            appState.scene.playMetronome = false
                            Task {
                                await Utils.MidiPlayer.shared.stopMetronome()
                                await Utils.MidiPlayer.shared.stopChords()
                            }
                            if appState.contentIsModified {
                                appState.scene.saveDoneAction = .showWelcomeView
                                appState.scene.showCloseDialog = true
                            } else {
                                appState.scene.showWelcomeView = true
                            }
                        }
                        .keyboardShortcut("o".ctrl())
                        MenuButton("Save") {
                            appState.editor.coreSettings.export.format = .chordPro
                            appState.scene.saveDoneAction = .noAction
                            appState.saveSong()
                            /// Add it to the recent songs list
                            recentSongs.addRecentSong(
                                content: appState.scene.originalContent,
                                coreSettings: appState.editor.coreSettings
                            )
                        }
                        .keyboardShortcut("s".ctrl())
                        MenuButton("Save As…") {
                            appState.editor.coreSettings.export.format = .chordPro
                            appState.scene.saveDoneAction = .noAction
                            appState.scene.saveSongAs.signal()
                        }
                        .keyboardShortcut("s".ctrl().shift())
                        MenuSection {
                            Submenu("Zoom") {
                                MenuButton("Zoom In") {
                                    appState.settings.theme.zoom = min(appState.settings.theme.zoom + 0.05, 2.0)
                                }
                                .keyboardShortcut("plus".ctrl())
                                .keyboardShortcut("equal".ctrl())
                                MenuButton("Zoom Out") {
                                    appState.settings.theme.zoom = max(appState.settings.theme.zoom - 0.05, 0.6)
                                }
                                .keyboardShortcut("minus".ctrl())
                                MenuSection {
                                    MenuButton("Reset Zoom") {
                                        appState.settings.theme.zoom = 1
                                    }
                                    .keyboardShortcut("0".ctrl())
                                }
                            }
                        }
                        Shared(app: app, window: window, appState: $appState)
                    }
                    .primary()
                    .tooltip("Main Menu")
                }
            }
            .headerBarTitle {
                WindowTitle(
                    subtitle: appState.editor.song.hasContent ? appState.subtitle : "Loading your song",
                    title: appState.editor.song.hasContent ? appState.title : "Chord Provider"
                )
            }
        }
    }
}

extension Views.Toolbar {

    /// The  toolbar for the Welcome `View`
    struct Welcome: View {
        /// The `AdwaitaApp`
        var app: AdwaitaApp
        /// The `AdwaitaWindow`
        var window: AdwaitaWindow
        /// The selected tab
        let welcomeTab: Views.Welcome.WelcomeTab
        /// The state of the application
        @Binding var appState: AppState
        /// The search string
        @Binding var search: String
        /// The songs folder
        let songsFolder: URL?
        /// The body of the `View`
        var view: Body {
            HeaderBar {
                /// Nothing at the start
            }
            end: {
                HStack(spacing: 5) {
                    if welcomeTab == .mySongs, songsFolder != nil {
                        SearchEntry()
                            .text($search)
                            .placeholderText("Search")
                            .transition(.crossfade)
                    }
                    Menu(icon: .default(icon: .openMenu)) {
                        Shared(app: app, window: window, appState: $appState)
                    }
                    .primary()
                    .tooltip("Main Menu")
                }
            }
            .headerBarTitle {
                WindowTitle(
                    subtitle: "Open or create a ChordPro song",
                    title: "Chord Provider"
                )
            }
        }
    }
}

extension Views.Toolbar {

    private struct Shared: View {
        /// The `AdwaitaApp`
        var app: AdwaitaApp
        /// The `AdwaitaWindow`
        var window: AdwaitaWindow
        /// The state of the application
        @Binding var appState: AppState
        /// The body of the `View`
        var view: Body {
            MenuSection {
                MenuButton("Chords Database") {
                    app.showWindow("database")
                }
                MenuButton("Preferences") {
                    appState.scene.showPreferencesDialog = true
                }
                .keyboardShortcut("comma".ctrl())
                MenuButton("Keyboard Shortcuts") {
                    appState.scene.showShortcutsDialog = true
                }
                .keyboardShortcut("question".ctrl())
                MenuButton("About Chord Provider", window: false) {
                    appState.scene.showAboutDialog = true
                }
                MenuButton("Quit", window: false) {
                    window.close()
                }
                .keyboardShortcut("q".ctrl())
            }
        }
    }
}
