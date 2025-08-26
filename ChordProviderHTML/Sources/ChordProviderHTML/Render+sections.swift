//
//  Render+sections.swift
//  ChordProviderHTML
//
//  Created by Nick Berendsen on 23/08/2025.
//

import Foundation
import ChordProviderCore

extension HtmlRender {

    static func sections(output: inout [String], sections: [Song.Section], chords: [ChordDefinition], settings: HtmlSettings) {
        for section in sections {

            switch section.environment {
            case .verse, .bridge, .chorus:
                lyricsSection(output: &output, section: section, settings: settings)
            case .repeatChorus:
                repeatChorusSection(output: &output, section: section, settings: settings)
            case .tab:
                tabSection(output: &output, section: section, settings: settings)
                //                }
            case .grid:
                //                if !settings.application.lyricsOnly {
                gridSection(output: &output, section: section, settings: settings)
                //                }
            case .textblock:
                textblockSection(output: &output, section: section, settings: settings)
            case .comment:
                commentSection(output: &output, section: section, settings: settings)
                //            case .strum:
                //                if !settings.application.lyricsOnly {
                //                    StrumSection(section: section, settings: settings)
                //                }
                //            case .image:
                //                ImageSection(section: section, settings: settings)
            default:
                /// Not supported or not a viewable environment
                break
            }
        }
    }


    static func wrapSongSection(
        section: Song.Section,
        label: String?,
        prominent: Bool = false,
        content: [String],
        settings: HtmlSettings
    ) -> String {

        var html = ""
        html += "<div class=\"label\">" + (label == nil ? "&nbsp;" : label ?? "") + "</div>"
        html += "<div class=\"section \(section.environment.rawValue) \(section.label.isEmpty ? "no-label" : "")\">"
        html += content.joined(separator: "\n")
        html += "</div>"

        return html
    }
}
