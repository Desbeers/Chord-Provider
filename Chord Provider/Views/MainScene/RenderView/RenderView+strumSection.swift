//
//  RenderView+strumSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension RenderView2 {

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
            self.width = settings.style.fonts.text.size * settings.scale
        }
        /// The body of the `View`
        var body: some View {
            VStack(alignment: .leading) {
                ForEach(section.lines) { line in
                    switch line.directive {
                    case .environmentLine:
                        if let strums = line.strum {
                            HStack {
                                ForEach(strums, id: \.self) {strumPart in
                                    HStack(spacing: 0) {
                                        ForEach(strumPart) { strum in
                                            let dash = strum.action == .slowUp || strum.action == .slowDown ? true : false
                                            VStack(spacing: 2) {
                                                Text(strum.topSymbol)
                                                    .foregroundStyle(settings.style.theme.foregroundMedium)
                                                    .font(settings.style.fonts.text.swiftUIFont(scale: settings.scale * 0.6))
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
                                                            .font(settings.style.fonts.text.swiftUIFont(scale: settings.scale * 0.6))
                                                            .help("Mute")
                                                    default:
                                                        Color.clear
                                                    }
                                                }
                                                .frame(width: width + 1, height: width * 2, alignment: .bottom)
                                                Text(strum.beat.isEmpty ? strum.tuplet : strum.beat)
                                                    .foregroundStyle(settings.style.theme.foregroundMedium)
                                                    .font(settings.style.fonts.text.swiftUIFont(scale: settings.scale * 0.6))
                                            }
                                        }
                                        Text(" ")
                                    }
                                }
                            }
                        }
                    case .comment:
                        CommentLabel(comment: line.plain ?? "", settings: settings)
                            .padding(.vertical, settings.style.fonts.text.size * settings.scale / 2)
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

extension RenderView {

    // MARK: Strum

    /// SwiftUI `View` for a strum section
    func strumSection(section: Song.Section) -> some View {
        let width: Double = song.settings.style.fonts.text.size * song.settings.scale
        return VStack(alignment: .leading) {
            ForEach(section.lines) { line in
                switch line.directive {
                case .environmentLine:
                    if let strums = line.strum {
                        HStack {
                            ForEach(strums, id: \.self) {strumPart in
                                HStack(spacing: 0) {
                                    ForEach(strumPart) { strum in
                                        let dash = strum.action == .slowUp || strum.action == .slowDown ? true : false
                                        VStack(spacing: 2) {
                                            Text(strum.topSymbol)
                                                .foregroundStyle(song.settings.style.theme.foregroundMedium)
                                                .font(song.settings.style.fonts.text.swiftUIFont(scale: song.settings.scale * 0.6))
                                            Group {
                                                switch strum.action {
                                                case .down, .accentedDown, .mutedDown, .slowDown:
                                                    ArrowView(
                                                        start: CGPoint(x: width / 2, y: 0),
                                                        end: CGPoint(x: width / 2, y: width * 2),
                                                        dash: dash,
                                                        color: song.settings.style.theme.foregroundMedium
                                                    )
                                                case .up, .accentedUp, .mutedUp, .slowUp:
                                                    ArrowView(
                                                        start: CGPoint(x: width / 2, y: width * 2),
                                                        end: CGPoint(x: width / 2, y: 0),
                                                        dash: dash,
                                                        color: song.settings.style.theme.foregroundMedium
                                                    )
                                                case .palmMute:
                                                    Text("x")
                                                        .foregroundStyle(song.settings.style.theme.foregroundMedium)
                                                        .font(song.settings.style.fonts.text.swiftUIFont(scale: song.settings.scale * 0.6))
                                                        .help("Mute")
                                                default:
                                                    Color.clear
                                                }
                                            }
                                            .frame(width: width + 1, height: width * 2, alignment: .bottom)
                                            Text(strum.beat.isEmpty ? strum.tuplet : strum.beat)
                                                .foregroundStyle(song.settings.style.theme.foregroundMedium)
                                                .font(song.settings.style.fonts.text.swiftUIFont(scale: song.settings.scale * 0.6))
                                        }
                                    }
                                    Text(" ")
                                }
                            }
                        }
                    }
                case .comment:
                    commentLabel(comment: line.plain ?? "")
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
