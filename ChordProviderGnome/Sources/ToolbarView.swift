//
//  File.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita

struct ToolbarView: View {

    @State private var about = false
    @Binding var openSong: Signal
    @Binding var saveSongAs: Signal
    @Binding var songURL: URL?
    var text: String
    var app: AdwaitaApp
    var window: AdwaitaWindow

    var view: Body {
        //HeaderBar.end {
        Menu(icon: .default(icon: .openMenu)) {
            MenuButton("Open") {
                openSong.signal()
            }
            .keyboardShortcut("o".ctrl())
            MenuButton("Save") {
                if let songURL {
                    try? text.write(to: songURL, atomically: true, encoding: String.Encoding.utf8)
                } else {
                    saveSongAs.signal()
                }
            }
            .keyboardShortcut("s".ctrl())
            MenuButton("Save As…") {
                saveSongAs.signal()
            }
            .keyboardShortcut("s".ctrl().shift())
            MenuButton(Loc.newWindow, window: false) {
                app.addWindow("main")
            }
            .keyboardShortcut("n".ctrl())
            MenuSection {
                MenuButton("About Chord Provider", window: false) {
                    about = true
                }
            }
        }
        //.primary()
        .tooltip(Loc.mainMenu)
        .aboutDialog(
            visible: $about,
            app: "Chord Provider",
            developer: "Nick Berendsen",
            version: "dev",
            icon: .custom(name: "nl.desbeers.chordprovider"),
            website: .init(string: "https://github.com/Desbeers/Chord-Provider")!,
            issues: .init(string: "https://github.com/Desbeers/Chord-Provider/issues")!
        )
        //}
    }

}
