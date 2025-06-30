//
//  RenderView+tabSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension RenderView2 {

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
                        Color.clear
                            .frame(height: settings.style.fonts.text.size / 2 * settings.scale)
                    case .comment:
                        CommentLabel(comment: line.plain ?? "", settings: settings)
                            .padding(.vertical, settings.style.fonts.text.size * settings.scale / 2)
                    default:
                        EmptyView()
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

    // MARK: Tab

    /// SwiftUI `View` for a tab section
    func tabSection(section: Song.Section) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(section.lines) { line in
                switch line.directive {
                case .environmentLine:
                    Text(line.plain ?? "")
                        .lineLimit(1)
                        .monospaced()
                        .minimumScaleFactor(0.1)
                case .emptyLine:
                    Color.clear
                        .frame(height: song.settings.style.fonts.text.size / 2 * song.settings.scale)
                case .comment:
                    commentLabel(comment: line.plain ?? "")
                        .padding(.vertical, song.settings.style.fonts.text.size * song.settings.scale / 2)
                default:
                    EmptyView()
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
