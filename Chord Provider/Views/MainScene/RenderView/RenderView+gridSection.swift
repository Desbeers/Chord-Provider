//
//  RenderView+gridSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension RenderView {

    // MARK: Grid

    /// SwiftUI `View` for a grid section
    func gridSection(section: Song.Section) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Grid(alignment: .leading) {
                ForEach(section.lines) { line in
                    switch line.directive {
                    case .environmentLine:
                        if let grids = line.grid {
                            GridRow {
                                ForEach(grids) { grid in
                                    ForEach(grid.parts) { part in
                                        if let chord = song.chords.first(where: { $0.id == part.chord }) {
                                            ChordView(
                                                settings: song.settings,
                                                sectionID: section.id,
                                                partID: part.id,
                                                chord: chord
                                            )
                                        } else {
                                            Text(part.text)
                                                .foregroundStyle(part.text == "|" || part.text == "." ? Color.primary : Color.red)
                                        }
                                    }
                                }
                            }
                        }
                    case .comment:
                        commentLabel(comment: line.plain)
                    default:
                        EmptyView()
                    }
                }
            }
        }
        .padding(.vertical, song.settings.scale)
        .wrapSongSection(
            label: section.label,
            settings: song.settings
        )
    }
}
