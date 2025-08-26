//
//  Render+parts.swift
//  ChordProviderHTML
//
//  Created by Nick Berendsen on 23/08/2025.
//

import Foundation
import ChordProviderCore

public extension HtmlRender {

    static func parts(output: inout [String], parts: [Song.Section.Line.Part], settings: HtmlSettings) {

        var html = "<div class=\"line\">"
        parts.forEach { part in
            html += "<div class=\"part\"><div class=\"chord\">"

            if let display = part.chordDefinition?.display {
                html += display
            } else {
                html += "&nbsp;\u{200c}"
            }
            html += "</div><div class=\"lyric\">\(part.text ?? "&nbsp;")\u{200c}</div></div>"
        }
        html += "</div>"
        output.append(html)
    }
}
