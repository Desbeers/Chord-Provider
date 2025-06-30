//
//  RenderView+gridSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension RenderView2 {

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
                                                    .font(settings.style.fonts.chord.swiftUIFont(scale: settings.scale))
                                            }
                                        }
                                    }
                                }
                            }
                        case .emptyLine:
                            Color.clear
                                .frame(height: settings.style.fonts.text.size / 2 * settings.scale)
                                .gridCellUnsizedAxes(.horizontal)
                        case .comment:
                            CommentLabel(comment: line.plain ?? "", settings: settings)
                                .padding(.vertical, settings.style.fonts.text.size * settings.scale / 2)
                        default:
                            EmptyView()
                        }
                    }
                }
            }
            .padding(.vertical, settings.scale)
            .wrapSongSection(
                label: section.label,
                settings: settings
            )
        }
    }
}

extension RenderView {

    // MARK: Grid

    /// SwiftUI `View` for a grid section
    func gridSection(section: Song.Section) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Grid(alignment: .leading, horizontalSpacing: 0, verticalSpacing: 0) {
                ForEach(section.lines) { line in
                    switch line.directive {
                    case .environmentLine:
                        if let grids = line.grid {
                            GridRow {
                                ForEach(grids) { grid in
                                    ForEach(grid.parts) { part in
                                        if let chord = song.chords.first(where: { $0.id == part.chord }) {
                                            ChordView(
                                                chord: chord,
                                                settings: song.settings
                                            )
                                        } else {
                                            Text(" \(part.text) ")
                                                .foregroundStyle(part.text == "|" || part.text == "." ? song.settings.style.fonts.text.color : Color.red)
                                                .font(song.settings.style.fonts.chord.swiftUIFont(scale: song.settings.scale))
                                        }
                                    }
                                }
                            }
                        }
                    case .emptyLine:
                        Color.clear
                            .frame(height: song.settings.style.fonts.text.size / 2 * song.settings.scale)
                            .gridCellUnsizedAxes(.horizontal)
                    case .comment:
                        commentLabel(comment: line.plain ?? "")
                            .padding(.vertical, song.settings.style.fonts.text.size * song.settings.scale / 2)
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
