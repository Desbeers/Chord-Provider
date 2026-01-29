//
//  Views+SingleChord.swift.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension GtkRender {

    /// The `View` for a single chord in a part
    struct SingleChord: View {
        /// The part containing the chord
        let part: Song.Section.Line.Part
        /// The settings
        let settings: ChordProviderSettings
        /// Bool to open the chord diagram
        @State private var openChordDiagram: Bool = false
        /// The body of the `View`
        var view: Body {
            if let chord = part.chordDefinition {
                Toggle("", isOn: $openChordDiagram)
                    .child {
                        Text(part.withMarkup(chord))
                            .useMarkup()
                            .style(.chord)
                    }
                    .flat()
                    .style(.chordDiagramButton)
                    .popover(visible: $openChordDiagram) {
                        if openChordDiagram {
                            VStack(spacing: 0) {
                                Views.MidiPlayer(chord: chord)
                                Views.ChordDiagram(chord: chord, settings: settings)
                            }
                        }
                    }
            }
        }
    }
}
