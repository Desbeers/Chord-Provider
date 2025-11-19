//
//  Views+Toolbar.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension Views {
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
        /// The body of the `View`
        var view: Body {
            HeaderBar {
                HStack(spacing: 5) {
                    Toggle(icon: .default(icon: .textEditor), isOn: $appState.settings.editor.showEditor)
                    .tooltip("Show the editor")
                    ToggleButton(icon: .default(icon: .objectFlipVertical), isOn: $appState.scene.isTransposed) {
                        appState.scene.showTransposeDialog = true
                    }
                    .tooltip(appState.settings.core.transposeTooltip)
                    DropDown(selection: $appState.settings.core.instrument, values: Chord.Instrument.allCases)
                        .tooltip("Select your instrument")
                    Toggle(icon: .default(icon: .viewDual), isOn: $appState.settings.app.columnPaging)
                        .tooltip("Show the song in columns")
                }
            }
            end: {
                HStack(spacing: 5) {
                    Button(icon: .default(icon: .helpAbout)) {
                        app.showWindow("debug")
                    }
                    .tooltip("See how your song is parsed")
                    Menu(icon: .default(icon: .openMenu)) {
                        MenuButton("Open") {
                            if appState.scene.dirty {
                                appState.scene.saveDoneAction = .showWelcomeScreen
                                appState.scene.showDirtyClose = true
                            } else {
                                appState.showWelcomeScreen()
                            }
                        }
                        .keyboardShortcut("o".ctrl())
                        MenuButton("Save") {
                            appState.settings.core.export.format = .chordPro
                            appState.scene.saveDoneAction = .noAction
                            appState.saveSong()
                        }
                        .keyboardShortcut("s".ctrl())
                        MenuButton("Save As…") {
                            appState.settings.core.export.format = .chordPro
                            appState.scene.saveDoneAction = .noAction
                            appState.scene.saveSongAs.signal()
                        }
                        .keyboardShortcut("s".ctrl().shift())
                        MenuSection {
                            Submenu("Zoom") {
                                MenuButton("Zoom In") {
                                    appState.settings.app.zoom = min(appState.settings.app.zoom + 0.05, 2.0)
                                }
                                .keyboardShortcut("plus".ctrl())
                                MenuButton("Zoom Out") {
                                    appState.settings.app.zoom = max(appState.settings.app.zoom - 0.05, 0.6)
                                }
                                .keyboardShortcut("minus".ctrl())
                                MenuSection {
                                    MenuButton("Reset Zoom") {
                                        appState.settings.app.zoom = 1
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
                    subtitle: appState.scene.showWelcome ? "Open or create a ChordPro song" : appState.subtitle,
                    title: "Chord Provider"
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
        /// The body of the `View`
        var view: Body {
            HeaderBar {
                /// Nothing at the start
            }
            end: {
                HStack(spacing: 5) {
                    if welcomeTab == .mySongs, appState.settings.app.songsFolder != nil {
                        SearchEntry()
                            .text($search)
                            .placeholderText("Search")
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
                    appState.scene.showPreferences = true
                }
                .keyboardShortcut("comma".ctrl())
                MenuButton("Keyboard Shortcuts") {
                    appState.scene.showKeyboardShortcuts = true
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
