//
//  Render.swift
//  ChordProviderHTML
//
//  Created by Nick Berendsen on 23/08/2025.
//

import Foundation
import ChordProviderCore

public enum HtmlRender {
    // Just a placeholder
}

public extension HtmlRender {

    static func main(song: Song, settings: HtmlSettings) -> String {

        var html = htmlPage

        var output: [String] = []

        output.append("<div class=\"header\">")
        output.append("<h1>\(song.metadata.title)</h1>")
        if let subtitle = song.metadata.subtitle {
            output.append("<h2>\(subtitle)</h2>")
        }
        output.append("</div>")

        html = html.replacingOccurrences(of: "**TITLE**", with: song.metadata.title)

        html = html.replacingOccurrences(of: "**HEADER**", with: output.joined(separator: "\n"))

        html = html.replacingOccurrences(of: "**CHORDS**", with: chords(chords: song.chords, settings: settings))

        output = []

        sections(output: &output, sections: song.sections, chords: song.chords, settings: settings)

        html = html.replacingOccurrences(of: "**CONTENT**", with: output.joined(separator: "\n"))

        return html
    }
}
