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
        init(chord: ChordDefinition, width: Double = 100, settings: ChordProviderSettings) {
            var chord = chord
            /// Mirror if needed
            if settings.diagram.mirror {
                chord.mirrorChordDiagram()
            }
            self.chord = chord
            self.width = width
            self.settings = settings
        }
        
        /// The chord definition
        let chord: ChordDefinition
        /// The width of the diagram
        var width: Double = 100
        /// The settings of the application
        let settings: ChordProviderSettings
        /// The body of the `View`
        var  view: Body {
            if chord.kind.knownChord {
                Widgets.Diagram(chord: chord, width: width, settings: settings)
                    .frame(minWidth: Int(width), minHeight: Int(width * 1.2))
                    .frame(maxWidth: Int(width))
                    .frame(maxHeight: Int(width * 1.2))
                    .valign(.center)
                    .halign(.center)
                    .id(settings.diagram.description + chord.define)
            } else {
                Text(chord.kind.description)
                    .wrap()
                    .style(.caption)
            }
        }
    }
}
