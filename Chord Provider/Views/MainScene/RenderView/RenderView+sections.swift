//
//  RenderView+sections.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

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
