//
//  ToolbarView.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

/// The `View` for the toolbar
struct ToolbarView: View {
    var app: AdwaitaApp
    var window: AdwaitaWindow
    @Binding var appState: AppState

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
                }
            }
        }
        end: {
            if appState.scene.showWelcome {
                Menu(icon: .default(icon: .openMenu)) {
                    MenuSection {
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
            } else {
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
        .headerBarTitle {
            WindowTitle(
                subtitle: appState.scene.showWelcome ? "" : appState.subtitle,
                title: "Chord Provider"
            )
        }
    }
}
