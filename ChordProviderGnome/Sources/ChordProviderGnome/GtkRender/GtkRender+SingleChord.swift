//
//  Views+SingleChord.swift.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension GtkRender {

    /// The `View` for a single chord in a part
    struct SingleChord: View {
        /// The part containing the chord
        let part: Song.Section.Line.Part
        /// Highlight the chord
        var highlight: Bool = false
        /// The state of the application
        let appState: AppState
        /// Bool to open the chord diagram
        @State private var openChordDiagram: Bool = false
        /// The body of the `View`
        var view: Body {
            switch part.content {
            case let .chord(definition, markup, _ ):
                chordToggle(chord: definition, markup: markup)
            case let .lyric(lyric):
                switch lyric.chordSlot {
                case let .chord(definition, markup):
                    chordToggle(chord: definition, markup: markup)
                default:
                    Views.Empty()
                }
            default:
                Views.Empty()
            }
        }
        /// The chord with a toggle to show the diagram
        func chordToggle(chord: ChordDefinition, markup: Song.TextPart?) -> AnyView {
            Toggle("", isOn: $openChordDiagram)
                .child {
                    Text(markup?.display ?? chord.display)
                        .useMarkup()
                        .highlight(highlight, color: appState.pangoAccentColor)
                        .zoom(appState.settings.theme.zoom)
                        .tooltip(chord.toolTip)
                        .style(chord.style)
                        .style(.chord)
                        .id(chord.description + highlight.description)
                }
                .flat()
                .style(.chordDiagramToggle)
                .popover(visible: $openChordDiagram) {
                    if openChordDiagram {
                        VStack(spacing: 0) {
                            Views.MidiPlayerButton(
                                chord: chord,
                                coreSettings: appState.editor.coreSettings
                            )
                            Views.ChordDiagram(
                                chord: chord,
                                coreSettings: appState.editor.coreSettings
                            )
                            if chord.knownChord, let strum = chord.strum {
                                Text(strum.display)
                                    .style(.caption)
                            }
                        }
                    }
                }
        }
    }
}
