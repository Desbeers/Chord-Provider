//
//  GtkRender+CommentLabel.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore
import Adwaita

extension GtkRender {

    /// The `View` for a chord diagram
    struct ChordDiagram: View {
        /// The current line of the song
        let line: Song.Section.Line
        /// The core settings
        let coreSettings: ChordProviderSettings
        /// The body of the `View`
        var view: Body {
            if let parts = line.parts {
                ForEach(parts, horizontal: true) { part in
                    if let chord = part.chordDefinition, chord.knownChord {
                        VStack(spacing: 0) {
                            Views.MidiPlayer(chord: chord, coreSettings: coreSettings)
                            Views.ChordDiagram(chord: chord, width: 50, coreSettings: coreSettings)
                        }
                    }
                }
            }
        }
    }
}
