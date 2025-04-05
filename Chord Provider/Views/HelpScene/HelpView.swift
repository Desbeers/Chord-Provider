//
//  HelpView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for help
struct HelpView: View {
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
                        await random()
                    }
                } label: {
                    Text("Random Colors")
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
                var settings = AppSettings()
                switch colorScheme {
                case .dark:
                    settings.style = AppSettings.Style.ColorPreset.dark.presets(style: settings.style)
                default:
                    settings.style = AppSettings.Style.ColorPreset.light.presets(style: settings.style)
                }

                let song = await ChordProParser.parse(id: UUID(), text: content, transpose: 0, settings: settings, fileURL: helpSong)
                if let export = try? await SongExport.export(
                    song: song, appSettings: settings
                ) {
                    data = export.pdf
                }
            }
        }
    }

    /// Show help with random colours
    func random() async {
        if
            let helpSong = Bundle.main.url(forResource: "Help", withExtension: "chordpro"),
            let content = try? String(contentsOf: helpSong, encoding: .utf8) {
            var settings = AppSettings()

            settings.style = AppSettings.Style.ColorPreset.random.presets(style: settings.style)

            let song = await ChordProParser.parse(id: UUID(), text: content, transpose: 0, settings: settings, fileURL: helpSong)
            if let export = try? await SongExport.export(
                song: song, appSettings: settings
            ) {
                data = export.pdf
            }
        }
    }
}
