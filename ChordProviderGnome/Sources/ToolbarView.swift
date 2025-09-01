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
            Toggle(icon: .default(icon: .textEditor), isOn: $settings.app.showEditor)
                .tooltip("Show Editor")
            Toggle(icon: .default(icon: .formatJustifyLeft), isOn: $settings.core.lyricOnly)
                .tooltip("Show only lyrics")
            Toggle(icon: .default(icon: .mediaPlaylistRepeat), isOn: $settings.core.repeatWholeChorus)
                .tooltip("Repeat whole chorus")
            DropDown(selection: $settings.core.instrument, values: Chord.Instrument.allCases)
        }
        end: {
            Menu(icon: .default(icon: .openMenu)) {
                MenuButton("Open") {
                    settings.app.openSong.signal()
                }
                .keyboardShortcut("o".ctrl())
                MenuButton("Save") {
                    if let songURL = settings.app.songURL {
                        try? settings.app.text.write(to: songURL, atomically: true, encoding: String.Encoding.utf8)
                    } else {
                        settings.app.saveSongAs.signal()
                    }
                }
                .keyboardShortcut("s".ctrl())
                MenuButton("Save As…") {
                    settings.app.saveSongAs.signal()
                }
                .keyboardShortcut("s".ctrl().shift())
                MenuButton("New Window", window: false) {
                    app.addWindow("main")
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
            WindowTitle(subtitle: settings.app.songURL?.lastPathComponent ?? "New Song", title: "Chord Provider")
        }
    }
}
