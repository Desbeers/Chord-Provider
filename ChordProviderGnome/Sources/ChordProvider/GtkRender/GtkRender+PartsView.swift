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
                                case let .chord(_, textPart):
                                    /// Show the chord name with a toggle to open its diagram
                                    GtkRender.SingleChord(part: part, coreSettings: coreSettings)
                                        .padding(lyric.display.count <=  textPart.display.count ? 6 : 0, .trailing)
                                case let .text(markup):
                                    /// Show the text in the chord slot
                                    Text(markup.display)
                                        .useMarkup()
                                        .style(.standard)
                                        .padding(lyric.display.count <=  markup.display.count ? 6 : 0, .trailing)
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
