//
//  RenderView+chorusSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension RenderView {

    // MARK: Chorus

    /// SwiftUI `View` for a chorus section
    func chorusSection(section: Song.Section) -> some View {
        VStack(alignment: .leading) {
            ForEach(section.lines) { line in
                switch line.directive {
                case .environmentLine:
                    if let parts = line.parts {
                        PartsView(
                            song: song,
                            sectionID: section.id,
                            parts: parts,
                            chords: song.chords
                        )
                    }
                case .comment:
                    commentLabel(comment: line.plain)
                default:
                    EmptyView()
                }
            }
        }
        .wrapSongSection(
            label: section.label.isEmpty ? "Chorus" : section.label,
            prominent: true,
            settings: song.settings
        )
    }
}
