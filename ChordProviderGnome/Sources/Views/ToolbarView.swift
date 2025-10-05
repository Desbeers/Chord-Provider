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
    @Binding var settings: AppSettings

    var view: Body {
        HeaderBar {
            if !settings.app.showWelcome {
                HStack {
                    Toggle(icon: .default(icon: .textEditor), isOn: $settings.editor.showEditor) {
                        if !settings.app.showWelcome {
                            switch settings.editor.showEditor {
                            case true:
                                settings.editor.splitter = settings.editor.restoreSplitter
                            case false:
                                settings.editor.splitter = 0
                            }
                        }
                    }
                    .tooltip("Show the editor")
                    ToggleButton(icon: .default(icon: .objectFlipVertical), isOn: $settings.app.isTransposed) {
                        settings.app.transposeDialog = true
                    }
                    .tooltip(settings.core.transposeTooltip)
                    DropDown(selection: $settings.core.instrument, values: Chord.Instrument.allCases)
                        .tooltip("Select your instrument")
                }
            }
        }
        end: {
            if !settings.app.showWelcome {
                Menu(icon: .default(icon: .openMenu)) {
                    MenuButton("Open") {
                        if settings.dirty {
                            settings.app.saveDoneAction = .openSong
                            settings.app.showDirtyClose = true
                        } else {
                            settings.app.source = ""
                            settings.app.originalSource = ""
                            settings.core.songURL = nil
                            settings.editor.showEditor = false
                            settings.editor.splitter = 0
                            settings.app.showWelcome = true
                        }
                    }
                    .keyboardShortcut("o".ctrl())
                    MenuButton("Save") {
                        if let songURL = settings.core.songURL {
                            try? settings.app.source.write(to: songURL, atomically: true, encoding: String.Encoding.utf8)
                            /// Set the toast
                            settings.app.toastMessage = "Saved \(songURL.deletingPathExtension().lastPathComponent)"
                            settings.app.showToast.signal()
                            /// Remember the content as  saved
                            settings.app.originalSource = settings.app.source
                        } else {
                            settings.core.export.format = .chordPro
                            settings.app.saveDoneAction = .noAction
                            settings.app.saveSongAs.signal()
                        }
                    }
                    .keyboardShortcut("s".ctrl())
                    MenuButton("Save As…") {
                        settings.core.export.format = .chordPro
                        settings.app.saveDoneAction = .noAction
                        settings.app.saveSongAs.signal()
                    }
                    .keyboardShortcut("s".ctrl().shift())
                    MenuButton("Export as HTML") {
                        settings.core.export.format = .html
                        settings.app.saveSongAs.signal()
                    }
                    MenuSection {
                        Submenu("Zoom") {
                            MenuButton("Zoom In") {
                                settings.app.zoom = min(settings.app.zoom + 0.05, 2.0)
                            }
                            .keyboardShortcut("plus".ctrl())
                            MenuButton("Zoom Out") {
                                settings.app.zoom = max(settings.app.zoom - 0.05, 0.6)
                            }
                            .keyboardShortcut("minus".ctrl())
                            MenuSection {
                                MenuButton("Reset Zoom") {
                                    settings.app.zoom = 1
                                }
                                .keyboardShortcut("0".ctrl())
                            }
                        }
                    }
                    MenuSection {
                        MenuButton("Preferences") {
                            settings.app.showPreferences = true
                        }
                        .keyboardShortcut("comma".ctrl())
                        MenuButton("About Chord Provider", window: false) {
                            settings.app.aboutDialog = true
                        }
                        MenuButton("Quit", window: false) {
                            if settings.dirty {
                                settings.app.saveDoneAction = .close
                                settings.app.showDirtyClose = true
                            } else {
                                window.close()
                            }
                        }
                        .keyboardShortcut("q".ctrl())
                    }
                }
                .primary()
                .tooltip("Main Menu")
                .aboutDialog(
                    visible: $settings.app.aboutDialog,
                    app: "Chord Provider",
                    developer: "Nick Berendsen",
                    version: "dev",
                    icon: .custom(name: "nl.desbeers.chordprovider"),
                    // swiftlint:disable:next force_unwrapping
                    website: .init(string: "https://github.com/Desbeers/Chord-Provider")!,
                    // swiftlint:disable:next force_unwrapping
                    issues: .init(string: "https://github.com/Desbeers/Chord-Provider/issues")!
                )
            }
            else {
                Menu(icon: .default(icon: .openMenu)) {
                    MenuSection {
                        MenuButton("Preferences") {
                            settings.app.showPreferences = true
                        }
                        .keyboardShortcut("comma".ctrl())
                        MenuButton("About Chord Provider", window: false) {
                            settings.app.aboutDialog = true
                        }
                        MenuButton("Quit", window: false) {
                            if settings.dirty {
                                settings.app.saveDoneAction = .close
                                settings.app.showDirtyClose = true
                            } else {
                                window.close()
                            }
                        }
                        .keyboardShortcut("q".ctrl())
                    }
                }
                .aboutDialog(
                    visible: $settings.app.aboutDialog,
                    app: "Chord Provider",
                    developer: "Nick Berendsen",
                    version: "dev",
                    icon: .custom(name: "nl.desbeers.chordprovider"),
                    // swiftlint:disable:next force_unwrapping
                    website: .init(string: "https://github.com/Desbeers/Chord-Provider")!,
                    // swiftlint:disable:next force_unwrapping
                    issues: .init(string: "https://github.com/Desbeers/Chord-Provider/issues")!
                )
            }
        }
        .headerBarTitle {
            WindowTitle(
                subtitle: settings.app.showWelcome ? "" : settings.subtitle,
                title: "Chord Provider"
            )
        }
    }
}
