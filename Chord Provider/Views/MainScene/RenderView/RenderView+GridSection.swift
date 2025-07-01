//
//  RenderView+GridSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

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
                        switch line.directive {
                        case .environmentLine:
                            if let grids = line.grid {
                                GridRow {
                                    ForEach(grids) { grid in
                                        ForEach(grid.parts) { part in
                                            if let chord = part.chordDefinition {
                                                RenderView.ChordView(
                                                    chord: chord,
                                                    settings: settings
                                                )
                                            } else {
                                                Text(" \(part.text) ")
                                                    .foregroundStyle(part.text == "|" || part.text == "." ? settings.style.fonts.text.color : Color.red)
                                                    .font(settings.style.fonts.chord.swiftUIFont(scale: settings.scale.scale))
                                            }
                                        }
                                    }
                                }
                            }
                        case .emptyLine:
                            Color.clear
                                .frame(height: settings.style.fonts.text.size / 2 * settings.scale.scale)
                                .gridCellUnsizedAxes(.horizontal)
                        case .comment:
                            CommentLabel(comment: line.plain ?? "", settings: settings)
                                .padding(.vertical, settings.style.fonts.text.size * settings.scale.scale / 2)
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
