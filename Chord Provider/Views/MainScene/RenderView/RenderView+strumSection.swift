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
                        HStack {
                            ForEach(strums, id: \.self) {strumPart in
                                HStack(spacing: 0) {
                                    ForEach(strumPart) { strum in
                                        VStack {
                                            Text(strum.strum)
                                                .font(song.settings.style.fonts.text.swiftUIFont(scale: song.settings.scale))
                                            Text(strum.beat.isEmpty ? strum.tuplet : strum.beat)
                                                .foregroundStyle(song.settings.style.theme.foregroundMedium)
                                                .font(song.settings.style.fonts.text.swiftUIFont(scale: song.settings.scale * 0.6))
                                        }
                                    }
                                    Text(" ")
                                }
                            }
                        }
                        .tracking(2 * song.settings.scale)
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
