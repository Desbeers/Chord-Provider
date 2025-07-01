//
//  RenderView+ChorusSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension RenderView {

    struct ChorusSection: View {
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
                        if let parts = line.parts {
                            PartsView(
                                parts: parts,
                                settings: settings
                            )
                        }
                    case .emptyLine:
                        Color.clear
                            .frame(height: settings.style.fonts.text.size * settings.scale.scale)
                    case .comment:
                        CommentLabel(comment: line.plain ?? "", settings: settings)
                            .padding(.vertical, settings.style.fonts.text.size * settings.scale.scale / 2)
                    default:
                        EmptyView()
                    }
                }
            }
            .wrapSongSection(
                label: section.label.isEmpty ? "Chorus" : section.label,
                prominent: true,
                settings: settings
            )
        }
    }
}
