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
        /// The core settings
        let coreSettings: ChordProviderSettings
        /// Bool to open the chord diagram
        @State private var openChordDiagram: Bool = false
        /// The body of the `View`
        var view: Body {
            if let chord = part.chordDefinition {
                Toggle("", isOn: $openChordDiagram)
                    .child {
                        Text(part.withMarkup(chord))
                            .useMarkup()
                            .tooltip(chord.toolTip)
                            .style(chord.style)
                            .style(.chord)
                            .id(chord)
                    }
                    .flat()
                    .style(.chordDiagramToggle)
                    .popover(visible: $openChordDiagram) {
                        if openChordDiagram {
                            VStack(spacing: 0) {
                                Views.MidiPlayer(chord: chord, coreSettings: coreSettings)
                                Views.ChordDiagram(chord: chord, coreSettings: coreSettings)
                                if chord.knownChord, let strum = chord.strum {
                                    Text(strum.description)
                                        .style(.caption)
                                }

                            }
                        }
                    }
            }
        }
    }
}
