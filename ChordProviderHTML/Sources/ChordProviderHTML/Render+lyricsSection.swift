//
//  Render+lyricsSection.swift
//  ChordProviderHTML
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension HtmlRender {

    static func lyricsSection(output: inout [String], section: Song.Section, settings: HtmlSettings) {

        var result: [String] = []

        for line in section.lines {
            switch line.type {
            case .songLine:
                if settings.options.lyricOnly {
                    result.append("<div class=\"line\">\(line.plain ?? "")</div>")
                } else if let lineParts = line.parts {
                    parts(output: &result, parts: lineParts, settings: settings)
                }
            case .emptyLine:
                result.append("<div class=\"line\">&nbsp;</div>")
            case .comment:
                commentLabel(output: &result, comment: line.plain, inline: true, settings: settings)
            default:
                break
            }
        }

        output.append(wrapSongSection(section: section, content: result, settings: settings))
    }
}
