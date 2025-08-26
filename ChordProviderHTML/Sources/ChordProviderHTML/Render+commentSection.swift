//
//  Render+commentSection.swift
//  ChordProviderHTML
//
//  Created by Nick Berendsen on 25/08/2025.
//

import Foundation
import ChordProviderCore

public extension HtmlRender {

    static func commentSection(output: inout [String], section: Song.Section, settings: HtmlSettings) {
        var result: [String] = []
        commentLabel(output: &result, comment: section.lines.first?.plain, settings: settings)
        output.append(wrapSongSection(section: section, label: nil, content: result, settings: settings))
    }

    static func commentLabel(output: inout [String], comment: String?, inline: Bool = false, settings: HtmlSettings) {

        var html = ""
        html += "<div class=\"line comment \(inline ? "comment-inline" : "comment-section")\">"
        html += comment ?? "Empty Comment"
        html += "</div>"

        output.append(html)
    }
}
