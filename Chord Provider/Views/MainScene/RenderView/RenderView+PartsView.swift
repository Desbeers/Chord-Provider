//
//  RenderView+PartsView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import ChordProviderCore

extension RenderView {

    // MARK: Parts

    /// SwiftUI `View` for parts of a line
    struct PartsView: View {
        /// The `parts` of a `line`
        let parts: [Song.Section.Line.Part]
        /// The settings for the song
        let settings: AppSettings
        /// The body of the `View`
        var body: some View {
            HStack(alignment: .bottom, spacing: 0) {
                ForEach(parts) { part in
                    VStack(alignment: .leading) {
                        if !settings.core.lyricsOnly, let chord = part.chordDefinition {
                            RenderView.ChordView(chord: chord, settings: settings)
                        }
                        /// See https://stackoverflow.com/questions/31534742/space-characters-being-removed-from-end-of-string-uilabel-swift
                        /// for the funny stuff added to the string...
                        Text(.init("\(part.text ?? " ")\u{200c}"))
                    }
                    .padding(.vertical, 2)
                }
            }
        }
    }
}
