//
//  RenderView+Sections.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import ChordProviderCore

extension RenderView {

    struct Sections: View {
        /// All the sections of the song
        let sections: [Song.Section]
        /// All the chords of the song
        let chords: [ChordDefinition]
        /// The settings for the song
        let settings: AppSettings
        /// The body of the `View`
        var body: some View {
            ForEach(sections) { section in
                switch section.environment {
                case .verse, .bridge, .chorus:
                    LyricsSection(section: section, settings: settings)
                case .repeatChorus:
                    RepeatChorusSection(
                        section: section,
                        sections: sections,
                        settings: settings
                    )
                case .tab:
                    if !settings.application.lyricsOnly {
                        TabSection(section: section, settings: settings)
                    }
                case .grid:
                    if !settings.application.lyricsOnly {
                        GridSection(section: section, settings: settings)
                    }
                case .textblock:
                    TextblockSection(section: section, settings: settings)
                case .comment:
                    CommentSection(section: section, settings: settings)
                case .strum:
                    if !settings.application.lyricsOnly {
                        StrumSection(section: section, settings: settings)
                    }
                case .image:
                    ImageSection(section: section, settings: settings)
                default:
                    /// Not supported or not a viewable environment
                    EmptyView()
                }
            }
        }
    }
}
