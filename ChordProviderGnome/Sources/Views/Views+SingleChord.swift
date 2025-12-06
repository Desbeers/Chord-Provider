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
        @State private var chordDiagram: Bool = false
        /// The body of the `View`
        var view: Body {
            if let chord = part.chordDefinition {
                Button("") {
                    chordDiagram.toggle()
                }
                .child {
                    Text(part.withMarkup(chord))
                        .useMarkup()
                        .style(.chord)
                }
                .flat()
                .style(.chordDiagramButton)
                .popover(visible: $chordDiagram) {
                    VStack(spacing: 0) {
                        Text(chord.display)
                            .style(.chord)
                        Widgets.ChordDiagram(chord: chord, settings: settings)
                    }
                }
            }
        }
    }
}
