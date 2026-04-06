//
//  GtkRender+GridSection.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension GtkRender {

    /// The `View` for a grid section
    struct GridSection: View {
        /// Init the `View`
        /// - Parameters:
        ///   - section: The Grid section
        ///   - coreSettings: The core settings
        ///   - zoom: The zoom factor
        init(section: Song.Section, tempo: Int, coreSettings: ChordProviderSettings, zoom: Double) {
            /// Convert the grids into columns
            self.section = section.gridColumns()
            self.coreSettings = coreSettings
            self.zoom = zoom
            let tempo = UInt64(60 / Double(tempo) * 1_000_000_000)
            Task {
                await Utils.MidiPlayer.shared.setGridChords(section: section, tempo: tempo, preset: coreSettings.midiPreset)
            }
        }
        /// The core settings
        let coreSettings: ChordProviderSettings
        /// The zoom factor
        let zoom: Double
        /// The current section of the song
        let section: Song.Section
        /// Toggle to play the grid with MIDI
        @State private var playToggle: Bool = false
        /// The body of the `View`
        var view: Body {
            VStack {
                ForEach(section.lines) { line in
                    switch line.type {
                    case .songLine:
                        if let elements = line.gridColumns?.grids {
                            Toggle(icon: .default(icon: .mediaPlaybackStart), isOn: $playToggle) {
                                if playToggle {
                                    Task {
                                        await Utils.MidiPlayer.shared.startChords()
                                    }
                                } else {
                                    Task {
                                        await Utils.MidiPlayer.shared.stopChords()
                                    }
                                }
                            }
                            .halign(.start)
                            .flat()
                            ForEach(elements, horizontal: true) { element in
                                Box {
                                    ForEach(element.cells, horizontal: false) { cell in
                                        ForEach(cell.parts, horizontal: true) { item in
                                            part(part: item)
                                        }
                                    }
                                    .homogeneous()
                                }
                                .homogeneous()
                            }
                        }
                    case .emptyLine:
                        EmptyLine()
                    case .comment:
                        CommentLabel(comment: line.plain)
                    default:
                        Views.Empty()
                    }
                }
            }
            .padding(10)
        }

        /// Render a part of the grid
        /// - Parameter part: The part to render
        /// - Returns: A `View`
        func part(part: Song.Section.Line.Part) -> AnyView {
            Box {
                if part.chordDefinition != nil {
                    SingleChord(part: part, coreSettings: coreSettings)
                } else if let strum = part.strum {
                    Widgets.BundleImage(strum: strum)
                        .pixelSize(Int(14 * zoom))
                        .style(.svgIcon)
                } else {
                    Text(part.withMarkup(part.text ?? " "))
                        .useMarkup()
                        .style(.sectionGrid)
                        .padding(5, .leading)
                }
            }
            .homogeneous()
            .valign(.center)
            .padding(2)
        }
    }
}
