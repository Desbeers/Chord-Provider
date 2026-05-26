//
//  GtkRender+PartsView.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension GtkRender {

    /// The `View` for parts of a song lyric
    struct PartsView: View {
        /// The parts of the song line
        let parts: [Song.Section.Line.Part]
        /// Bool if the line has lyrics
        let lineHasLyrics: Bool
        /// Bool if the line has chords
        let lineHasChords: Bool
        /// The core settings
        let coreSettings: ChordProviderSettings
        /// The body of the `View`
        var view: Body {
            ForEach(parts, horizontal: true) { part in
                switch part.content {
                case let .lyric(lyric):
                    Box {
                        if lineHasChords {
                            Box {
                                switch lyric.chordSlot {
                                case .chord:
                                    /// Show the chord name with a toggle to open its diagram
                                    GtkRender.SingleChord(part: part, coreSettings: coreSettings)
                                case let .text(markup):
                                    Toggle("", isOn: .constant(false))
                                        .child {
                                            Text(markup.display)
                                                .useMarkup()
                                                .style(.chord)
                                        }
                                        .flat()
                                        .style(.chordDiagramToggle)
                                        .insensitive()
                                case .empty:
                                    /// Fill the slot or else the lyric will move up
                                    Text(" ")
                                }
                            }
                            .halign(.start)
                            .style(.chord)
                        }
                        if lineHasLyrics {
                            Text(lyric.display)
                                .useMarkup()
                                .style(.standard)
                                .halign(.start)
                        }
                    }
                    .homogeneous(lineHasLyrics && lineHasChords)
                default:
                    /// Here we only render lyrics parts, nothing else
                    Views.Empty()
                }
            }
        }
    }
}
