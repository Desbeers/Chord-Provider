//
//  RenderView+strumSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension RenderView {

    // MARK: Strum

    /// SwiftUI `View` for a strum section
    func strumSection(section: Song.Section) -> some View {
        VStack(alignment: .leading) {
            ForEach(section.lines) { line in
                switch line.directive {
                case .environmentLine:
                    if let strums = line.strum {
                        ForEach(strums) {strum in
                            Text(strum)
                        }
                        .tracking(2 * song.settings.scale)
                        .monospaced()
                    }
                case .comment:
                    commentLabel(comment: line.plain)
                default:
                    EmptyView()
                }
            }
        }
        .wrapSongSection(
            label: section.label,
            settings: song.settings
        )
    }
}
