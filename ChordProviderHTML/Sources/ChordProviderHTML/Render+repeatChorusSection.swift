//
//  Render+repeatChorusSection.swift
//  ChordProviderHTML
//
//  Created by Nick Berendsen on 25/08/2025.
//

import Foundation
import ChordProviderCore

extension HtmlRender {

    static func repeatChorusSection(output: inout [String], section: Song.Section, settings: HtmlSettings) {
        var result: [String] = []
        result.append("<div class=\"line repeat-chorus\">")
        result.append(section.lines.first?.plain ?? section.label)
        result.append("</div>")

        output.append(wrapSongSection(section: section, content: result, settings: settings))
    }
}
