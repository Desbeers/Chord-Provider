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

    static public func main(song: Song, settings: HtmlSettings) -> String {

        var html = """
                   <!DOCTYPE html>
                   <html lang="en">
                   <head>
                     <meta charset="utf-8">
                     <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=yes">
                   <style>
                   :root {
                     supported-color-schemes: light dark;\n
                   """
//        /// Add  colors from the assets catalog  to the css
//        html += "--accentColor: \(Color.accentHtmlColor);\n"
//        html += "--highlightColor: \(Color.highlightHtmlColor);\n"
//        html += "--sectionColor: \(Color.sectionHtmlColor);\n"
//        html += "--commentBackground: \(Color.commentHtmlBackground);\n"
//        html += "}\n"
//        /// Add the main CSS
//        if let filepath = Bundle.main.path(forResource: "style", ofType: "css") {
//            do {
//                let contents = try String(contentsOfFile: filepath)
//                html += contents
//            } catch {
//                print(error)
//            }
//        }

        html += style
        html += "}\n"

        html += """
                </style>
                </head>
                <body>
                <div id="container">
                <div id="grid">
                """


        var output: [String] = []

        output.append("<h1>\(song.metadata.title)</h1>")
        if let subtitle = song.metadata.subtitle{
            output.append("<h2>\(subtitle)</h2>")
        }

        sections(output: &output, sections: song.sections, chords: song.chords, settings: settings)
        html += output.joined(separator: "\n")
        html += "</div>"
        html += "</div>"
        html += "</body></html>"

        return html
    }
}
