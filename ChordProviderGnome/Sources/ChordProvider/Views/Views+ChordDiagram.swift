//
//  Views+ChordDiagram.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import ChordProviderCore
import Adwaita

extension Views {

    /// The `View` for a chord diagram
    struct ChordDiagram: View {
        init(
            chord: ChordDefinition,
            width: Double = 100,
            coreSettings: ChordProviderSettings
        ) {
            var chord = chord
            /// Mirror if needed
            if coreSettings.diagram.mirror {
                chord.mirrorChordDiagram()
            }
            self.chord = chord
            self.width = width
            self.coreSettings = coreSettings
        }
        /// The chord definition
        let chord: ChordDefinition
        /// The width of the diagram
        var width: Double = 100
        /// The core settings
        let coreSettings: ChordProviderSettings
        /// The body of the `View`
        var  view: Body {
            if chord.kind.knownChord {
                Widgets.ChordDiagram(chord: chord, width: width, coreSettings: coreSettings)
                    .frame(minWidth: Int(width), minHeight: Int(width * 1.2))
                    .frame(maxWidth: Int(width))
                    .frame(maxHeight: Int(width * 1.2))
                    .valign(.center)
                    .halign(.center)
                    .id(coreSettings.diagram.description + chord.description)
            } else {
                Text(chord.kind.description)
                    .wrap()
                    .style(.caption)
            }
        }
    }
}
