//
//  File.swift
//  ChordProviderHTML
//
//  Created by Nick Berendsen on 26/08/2025.
//

import Foundation
import ChordProviderCore

extension   HtmlRender {

    static func tabSection(output: inout [String], section: Song.Section, settings: HtmlSettings) {
        var result: [String] = []
        for line in section.lines {
            switch line.type {
            case .songLine:
                result.append("<div class=\"line\">\(line.plain ?? "&nbsp;")</div>")
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
