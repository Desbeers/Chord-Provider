//
//  Render.swift
//  ChordProviderHTML
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

/// Render a song into a HTML page
public enum HtmlRender {
    // Just a placeholder
}

public extension HtmlRender {

    /// Render a song into a HTML page
    /// - Parameters:
    ///   - song: The song to render
    ///   - settings: The settings
    /// - Returns: A complete HTML page
    static func render(song: Song, settings: ChordProviderSettings) -> String {

        var html = htmlPage

        var output: [String] = []

        output.append("<div class=\"header\">")
        output.append("<h1>\(song.metadata.title)</h1>")
        if let subtitle = song.metadata.subtitle {
            output.append("<h2>\(subtitle)</h2>")
        }
        output.append("</div>")

        html.replace("**TITLE**", with: song.metadata.title)

        html.replace("**HEADER**", with: output.joined(separator: "\n"))

        if settings.lyricsOnly {
            html.replace("**CHORDS**", with: "")
        } else {
            html.replace("**CHORDS**", with: chords(chords: song.chords, settings: settings))
        }

        output = []

        sections(output: &output, song: song, chords: song.chords, settings: settings)

        html.replace("**CONTENT**", with: output.joined(separator: "\n"))

        return html
    }
}
