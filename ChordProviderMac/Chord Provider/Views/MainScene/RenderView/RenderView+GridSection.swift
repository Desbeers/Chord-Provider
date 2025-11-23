//
//  RenderView+GridSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import ChordProviderCore

extension RenderView {

    struct GridSection: View {
        /// The section of the song
        let section: Song.Section
        /// The settings for the song
        let settings: AppSettings
        /// The body of the `View`
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                Grid(alignment: .leading, horizontalSpacing: 0, verticalSpacing: 0) {
                    ForEach(section.lines) { line in
                        switch line.type {
                        case .songLine:
                            if let grids = line.grid {
                                GridRow {
                                    ForEach(grids) { grid in
                                        HStack {
                                            ForEach(grid.cells) { cell in
                                                ForEach(cell.parts) { part in
                                                    if let chord = part.chordDefinition {
                                                        RenderView.ChordView(
                                                            chord: chord,
                                                            settings: settings
                                                        )
                                                    } else if let strum = part.strum {
                                                        Text(" \(strum.symbol)")
                                                            .foregroundStyle(settings.style.fonts.text.color)
                                                            .font(settings.style.fonts.chord.swiftUIFont(scale: settings.scale.magnifier))
                                                    } else {
                                                        Text(" \(part.text ?? "") ")
                                                            .foregroundStyle(settings.style.fonts.text.color)
                                                            .font(settings.style.fonts.chord.swiftUIFont(scale: settings.scale.magnifier))
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        case .emptyLine:
                            EmptyLine(settings: settings)
                                .gridCellUnsizedAxes(.horizontal)
                        case .comment:
                            CommentLabel(comment: line.plain, inline: true, settings: settings)
                        default:
                            EmptyView()
                        }
                    }
                }
            }
            .wrapSongSection(
                label: section.label,
                settings: settings
            )
        }
    }
}
