//
//  Render+sections.swift
//  ChordProviderHTML
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension HtmlRender {

    static func sections(output: inout [String], song: Song, chords: [ChordDefinition], settings: ChordProviderSettings) {
        for section in song.sections {
            switch section.environment {
            case .verse, .bridge, .chorus:
                lyricsSection(output: &output, section: section, settings: settings)
            case .repeatChorus:
                /// Check if we have to repeat the whole chorus
                if
                    settings.repeatWholeChorus,
                    let lastChorus = song.sections.last(
                        where: { $0.environment == .chorus && $0.arguments?[.label] == section.lines.first?.plain }
                    ) {
                    lyricsSection(output: &output, section: lastChorus, settings: settings)
                } else {
                    repeatChorusSection(output: &output, section: section, settings: settings)
                }
            case .tab:
                if !settings.lyricOnly {
                    tabSection(output: &output, section: section, settings: settings)
                }
            case .grid:
                if !settings.lyricOnly {
                    gridSection(output: &output, section: section, settings: settings)
                }
            case .textblock:
                textblockSection(output: &output, section: section, settings: settings)
            case .comment:
                commentSection(output: &output, section: section, settings: settings)
            default:
                /// Not supported or not a viewable environment
                break
            }
        }
    }


    static func wrapSongSection(
        section: Song.Section,
        content: [String],
        settings: ChordProviderSettings
    ) -> String {

        let environment = section.environment.rawValue
        let label = section.label.isEmpty ? "&nbsp;" : section.label

        var html = ""
        html += "<div class=\"label\"><span class=\"\(environment)\">" + (label) + "</span></div>"
        html += "<div class=\"section \(environment) \(section.label.isEmpty ? "no-label" : "")\">"
        html += content.joined(separator: "\n")
        html += "</div>"
        return html
    }
}
