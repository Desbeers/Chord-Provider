//
//  Views+SingleChord.swift.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension Views {

    /// The `View` for a single chord in a part
    struct SingleChord: View {
        /// The part containing the chord
        let part: Song.Section.Line.Part
        /// The settings
        let settings: AppSettings
        /// Bool to open the chord diagram
        @State private var openChordDiagram: Bool = false
        /// The body of the `View`
        var view: Body {
            if let chord = part.chordDefinition {
                Button("") {
                    openChordDiagram.toggle()
                }
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
                            Text(chord.display)
                                .style(.chord)
                            if !chord.status.knownChord {
                                Text(chord.status.description)
                                    .style(.caption)
                            } else {
                                Widgets.ChordDiagram(chord: chord, settings: settings)
                            }
                        }
                    }
                }
                .id(chord.define)
            }
        }
    }
}
