//
//  RenderView+StrumSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension RenderView {

    struct StrumSection: View {
        /// The section of the song
        let section: Song.Section
        /// The settings for the song
        let settings: AppSettings
        /// Calculated width for a strum
        let width: Double
        /// Init the struct
        init(section: Song.Section, settings: AppSettings) {
            self.section = section
            self.settings = settings
            self.width = settings.style.fonts.text.size * settings.scale.magnifier
        }
        /// The body of the `View`
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(section.lines) { line in
                    switch line.type {
                    case .songLine:
                        if let strums = line.strum {
                            HStack {
                                ForEach(strums, id: \.self) {strumPart in
                                    HStack(spacing: 0) {
                                        ForEach(strumPart) { strum in
                                            let dash = strum.action == .slowUp || strum.action == .slowDown ? true : false
                                            VStack(spacing: 2) {
                                                Text(strum.topSymbol)
                                                    .foregroundStyle(settings.style.theme.foregroundMedium)
                                                    .font(settings.style.fonts.text.swiftUIFont(scale: settings.scale.magnifier * 0.6))
                                                Group {
                                                    switch strum.action {
                                                    case .down, .accentedDown, .mutedDown, .slowDown:
                                                        ArrowView(
                                                            start: CGPoint(x: width / 2, y: 0),
                                                            end: CGPoint(x: width / 2, y: width * 2),
                                                            dash: dash,
                                                            color: settings.style.theme.foregroundMedium
                                                        )
                                                    case .up, .accentedUp, .mutedUp, .slowUp:
                                                        ArrowView(
                                                            start: CGPoint(x: width / 2, y: width * 2),
                                                            end: CGPoint(x: width / 2, y: 0),
                                                            dash: dash,
                                                            color: settings.style.theme.foregroundMedium
                                                        )
                                                    case .palmMute:
                                                        Text("x")
                                                            .foregroundStyle(settings.style.theme.foregroundMedium)
                                                            .font(settings.style.fonts.text.swiftUIFont(scale: settings.scale.magnifier * 0.6))
                                                            .help("Mute")
                                                    default:
                                                        Color.clear
                                                    }
                                                }
                                                .frame(width: width + 1, height: width * 2, alignment: .bottom)
                                                Text(strum.beat.isEmpty ? strum.tuplet : strum.beat)
                                                    .foregroundStyle(settings.style.theme.foregroundMedium)
                                                    .font(settings.style.fonts.text.swiftUIFont(scale: settings.scale.magnifier * 0.6))
                                            }
                                        }
                                        Text(" ")
                                    }
                                }
                            }
                        }
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
