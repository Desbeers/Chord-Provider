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

    /// The `View` for the toolbar
    struct Toolbar: View {
        /// The `AdwaitaApp`
        var app: AdwaitaApp
        /// The `AdwaitaWindow`
        var window: AdwaitaWindow
        /// The state of the application
        @Binding var appState: AppState
        /// The body of the `View`
        var view: Body {
            HeaderBar {
                if !appState.scene.showWelcome {
                    HStack(spacing: 5) {
                        Toggle(icon: .default(icon: .textEditor), isOn: $appState.settings.editor.showEditor) {
                            if !appState.scene.showWelcome {
                                switch appState.settings.editor.showEditor {
                                case true:
                                    appState.settings.editor.splitter = appState.settings.editor.restoreSplitter
                                case false:
                                    appState.settings.editor.splitter = 0
                                }
                            }
                        }
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
                    .transition(.crossfade)
                }
            }
            end: {
                if appState.scene.showWelcome {
                    HStack(spacing: 5) {
                        if appState.settings.app.welcomeTab == .mySongs, appState.settings.app.songsFolder != nil {
                            SearchEntry()
                                .text($appState.scene.search)
                                .placeholderText("Search")
                        }
                        Menu(icon: .default(icon: .openMenu)) {
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
                        .primary()
                        .tooltip("Main Menu")
                    }
                } else {
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
                            MenuButton("Export as HTML") {
                                appState.settings.core.export.format = .html
                                appState.scene.saveDoneAction = .noAction
                                appState.scene.saveSongAs.signal()
                            }
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
                                    appState.closeWindow(window: window)
                                }
                                .keyboardShortcut("q".ctrl())
                            }
                        }
                        .primary()
                        .tooltip("Main Menu")
                    }
                }
            }
            .headerBarTitle {
                WindowTitle(
                    subtitle: appState.scene.showWelcome ? "Open or create a ChordPro song" : appState.subtitle,
                    title: "Chord Provider"
                )
            }
            .shortcutsDialog(visible: $appState.scene.showKeyboardShortcuts)
            .shortcutsSection("Song") { section in
                section
                    .shortcutsItem("Open", accelerator: "o".ctrl())
                    .shortcutsItem("Save", accelerator: " s".ctrl())
                    .shortcutsItem("Save As", accelerator: " s".ctrl().shift())
            }
            .shortcutsSection("Zoom") { section in
                section
                    .shortcutsItem("Zoom In", accelerator: "plus".ctrl())
                    .shortcutsItem("Zoom Out", accelerator: " minus".ctrl())
                    .shortcutsItem("Reset Zoom", accelerator: " 0".ctrl())
            }
            .shortcutsSection("General") { section in
                section
                    .shortcutsItem("Show preferences", accelerator: "comma".ctrl())
                    .shortcutsItem("Show keyboard shortcuts", accelerator: "question".ctrl())
            }
            .shortcutsSection { $0.shortcutsItem("Quit Chord Provider", accelerator: "q".ctrl()) }
        }
    }
}
