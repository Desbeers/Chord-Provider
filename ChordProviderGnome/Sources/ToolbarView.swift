//
//  File.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

struct ToolbarView: View {
    var app: AdwaitaApp
    var window: AdwaitaWindow
    @Binding var settings: AppSettings

    var view: Body {
        HeaderBar {
            ToggleButton(icon: .default(icon: .textEditor), isOn: $settings.app.showEditor) {
                settings.app.splitter = settings.app.splitter == 0 ? 500 : 0
                settings.app.showEditor = settings.app.splitter == 0 ? false : true
            }
            .tooltip("Show the editor")
            Toggle(icon: .default(icon: .formatJustifyLeft), isOn: $settings.core.lyricsOnly)
                .tooltip("Show only lyrics")
            Toggle(icon: .default(icon: .mediaPlaylistRepeat), isOn: $settings.core.repeatWholeChorus)
                .tooltip("Repeat whole chorus")
            ToggleButton(icon: .default(icon: .objectFlipVertical), isOn: $settings.app.isTransposed) {
                settings.app.transposeDialog = true
            }
            .tooltip(settings.core.transposeTooltip)
            DropDown(selection: $settings.core.instrument, values: Chord.Instrument.allCases)
                .tooltip("Select your instrument")
        }
        end: {
            Menu(icon: .default(icon: .openMenu)) {
                MenuButton("Open") {
                    settings.app.openSong.signal()
                }
                .keyboardShortcut("o".ctrl())
                MenuButton("Save") {
                    if let songURL = settings.core.songURL {
                        try? settings.app.source.write(to: songURL, atomically: true, encoding: String.Encoding.utf8)
                        /// Set the toast
                        settings.app.toastMessage = "Saved \(songURL.deletingPathExtension().lastPathComponent)"
                        settings.app.showToast.signal()
                    } else {
                        settings.core.export.format = .chordPro
                        settings.app.saveSongAs.signal()
                    }
                }
                .keyboardShortcut("s".ctrl())
                MenuButton("Save As…") {
                    settings.app.saveSongAs.signal()
                }
                .keyboardShortcut("s".ctrl().shift())
                MenuButton("Export as HTML") {
                    settings.core.export.format = .html
                    settings.app.saveSongAs.signal()
                }
                MenuSection {
                    MenuButton("New Window", window: false) {
                        app.addWindow("main")
                    }
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
                    MenuButton("About Chord Provider", window: false) {
                        settings.app.aboutDialog = true
                    }
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
        .headerBarTitle {
            WindowTitle(
                subtitle: settings.subtitle,
                title: "Chord Provider"
            )
        }
    }
}
