//
//  RenderView+sections.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension RenderView2 {

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
                case .verse, .bridge:
                    VerseSection(section: section, settings: settings)
                case .chorus:
                    ChorusSection(section: section, settings: settings)
                case .repeatChorus:
                    RepeatChorusSection(
                        section: section,
                        sections: sections,
                        settings: settings
                    )
                case .tab:
                    if !settings.shared.lyricsOnly {
                        TabSection(section: section, settings: settings)
                    }
                case .grid:
                    if !settings.shared.lyricsOnly {
                        GridSection(section: section, settings: settings)
                    }
                case .textblock:
                    TextblockSection(section: section, settings: settings)
                case .comment:
                    CommentSection(section: section, settings: settings)
                case .strum:
                    if !settings.shared.lyricsOnly {
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

extension RenderView {

    /// The song sections of the `View`
    var sections: some View {
        ForEach(song.sections) { section in
            switch section.environment {
            case .verse, .bridge:
                verseSection(section: section)
            case .chorus:
                chorusSection(section: section)
            case .repeatChorus:
                repeatChorusSection(section: section)
            case .tab:
                if !song.settings.shared.lyricsOnly {
                    tabSection(section: section)
                }
            case .grid:
                if !song.settings.shared.lyricsOnly {
                    gridSection(section: section)
                }
            case .textblock:
                textblockSection(section: section)
            case .abc:
                /// Not supported
                EmptyView()
            case .comment:
                commentSection(section: section)
            case .strum:
                if !song.settings.shared.lyricsOnly {
                    strumSection(section: section)
                }
            case .image:
                imageSection(section: section)
            case .metadata:
                /// Don't render metadata
                EmptyView()
            case .emptyLine:
                /// Don't render empty lines when not in an environment
                EmptyView()
            case .sourceComment, .none:
                /// Not an environment
                EmptyView()
            }
        }
    }
}
