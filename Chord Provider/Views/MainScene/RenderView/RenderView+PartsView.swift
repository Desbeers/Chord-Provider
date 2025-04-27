//
//  RenderView+PartsView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension RenderView {

    // MARK: Parts

    /// SwiftUI `View` for parts of a line
    struct PartsView: View {
        /// The ``Song``
        let song: Song
        /// The ID of the section
        let sectionID: Int
        /// The `parts` of a `line`
        let parts: [Song.Section.Line.Part]
        /// The chords of the song
        let chords: [ChordDefinition]
        /// The body of the `View`
        var body: some View {
            HStack(alignment: .bottom, spacing: 0) {
                ForEach(parts) { part in
                    VStack(alignment: .leading) {
                        if !song.settings.shared.lyricsOnly, let chord = chords.first(where: { $0.id == part.chord }) {
                            ChordView(settings: song.settings, sectionID: sectionID, partID: part.id, chord: chord)
                        } else if !song.settings.shared.lyricsOnly {
                            /// A line without a chord
                            Text(" ")
                                .font(song.settings.style.fonts.chord.swiftUIFont(scale: song.settings.scale))
                        }
                        /// See https://stackoverflow.com/questions/31534742/space-characters-being-removed-from-end-of-string-uilabel-swift
                        /// for the funny stuff added to the string...
                        Text("\(part.text)\u{200c}")
                    }
                    .padding(.vertical, song.settings.scale)
                }
            }
        }
    }
}
