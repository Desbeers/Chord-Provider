//
//  RenderView+TabSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension RenderView {

    struct TabSection: View {
        /// The section of the song
        let section: Song.Section
        /// The settings for the song
        let settings: AppSettings
        /// The body of the `View`
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(section.lines) { line in
                    switch line.directive {
                    case .environmentLine:
                        Text(line.plain ?? "")
                            .lineLimit(1)
                            .monospaced()
                            .minimumScaleFactor(0.1)
                    case .emptyLine:
                        EmptyLine(settings: settings)
                    case .comment:
                        CommentLabel(comment: line.plain, inline: true, settings: settings)
                    default:
                        EmptyView()
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
