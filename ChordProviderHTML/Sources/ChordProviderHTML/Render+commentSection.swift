//
//  Render+commentSection.swift
//  ChordProviderHTML
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension HtmlRender {

    static func commentSection(output: inout [String], section: Song.Section, settings: ChordProviderSettings) {
        var result: [String] = []
        commentLabel(output: &result, comment: section.lines.first?.plain, settings: settings)
        output.append(wrapSongSection(section: section, content: result, settings: settings))
    }

    static func commentLabel(output: inout [String], comment: String?, inline: Bool = false, settings: ChordProviderSettings) {

        var html = ""
        html += "<div class=\"line comment \(inline ? "comment-inline" : "comment-section")\">"
        html += comment ?? "Empty Comment"
        html += "</div>"

        output.append(html)
    }
}
