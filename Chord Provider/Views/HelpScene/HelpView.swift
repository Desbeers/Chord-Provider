//
//  HelpView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import ChordProviderCore

/// SwiftUI `View` for help
struct HelpView: View {
    /// The observable state of the application
    @Environment(AppStateModel.self) private var appState
    /// The settings
    @State var settings = AppSettings()
    /// The optional PDF data
    @State private var data: Data?
    /// Check the color scheme
    @Environment(\.colorScheme) var colorScheme
    /// The body of the `View`
    var body: some View {
        VStack {
            if let data {
                AppKitUtils.PDFKitRepresentedView(data: data)
            } else {
                ProgressView()
            }
            Divider()
            HStack {
                Button {
                    Task {
                        await randomColors()
                    }
                } label: {
                    Text("Random Colors")
                }
                Button {
                    Task {
                        await randomFonts()
                    }
                } label: {
                    Text("Random Fonts")
                }
                Spacer()
                if let url = URL(string: "https://github.com/Desbeers/Chord-Provider") {
                    Link(destination: url) {
                        Text("Chord Provider on GitHub")
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding([.horizontal, .bottom])
        }
        .frame(width: 800)
        .frame(height: 800, alignment: .top)
        .task(id: colorScheme) {
            if
                let helpSong = Bundle.main.url(forResource: "Help", withExtension: "chordpro"),
                let content = try? String(contentsOf: helpSong, encoding: .utf8) {
                switch colorScheme {
                case .dark:
                    settings.style = AppSettings.Style.ColorPreset.dark.presets(style: settings.style)
                default:
                    settings.style = AppSettings.Style.ColorPreset.light.presets(style: settings.style)
                }
                var song = Song(id: UUID(), content: content)
                song.metadata.fileURL = helpSong
                song = ChordProParser.parse(song: song, instrument: .guitar, prefixes: [])
                if let export = try? await SongExport.export(
                    song: song,
                    settings: settings
                ) {
                    data = export.pdf
                }
            }
        }
    }

    /// Show help with random colours
    func randomColors() async {
        if
            let helpSong = Bundle.main.url(forResource: "Help", withExtension: "chordpro"),
            let content = try? String(contentsOf: helpSong, encoding: .utf8) {
            settings.style = AppSettings.Style.ColorPreset.random.presets(style: settings.style)
            var song = Song(id: UUID(), content: content)
            song.metadata.fileURL = helpSong
            song = ChordProParser.parse(song: song, instrument: .guitar, prefixes: [])
            if let export = try? await SongExport.export(
                song: song,
                settings: settings
            ) {
                data = export.pdf
            }
        }
    }

    /// Show help with random fonts
    func randomFonts() async {
        if
            let helpSong = Bundle.main.url(forResource: "Help", withExtension: "chordpro"),
            let content = try? String(contentsOf: helpSong, encoding: .utf8) {
            settings.style = AppSettings.Style.FontPreset.random.presets(style: settings.style, fonts: appState.fonts)
            var song = Song(id: UUID(), content: content)
            song.metadata.fileURL = helpSong
            song = ChordProParser.parse(song: song, instrument: .guitar, prefixes: [])
            if let export = try? await SongExport.export(
                song: song,
                settings: settings
            ) {
                data = export.pdf
            }
        }
    }
}
