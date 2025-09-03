//
//  Render+repeatChorusSection.swift
//  ChordProviderHTML
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension HtmlRender {

    static func repeatChorusSection(output: inout [String], section: Song.Section, settings: ChordProviderSettings) {
        var result: [String] = []
        result.append("<div class=\"line repeat-chorus\">")
        result.append(section.lines.first?.plain ?? section.label)
        result.append("</div>")

        output.append(wrapSongSection(section: section, content: result, settings: settings))
    }
}
