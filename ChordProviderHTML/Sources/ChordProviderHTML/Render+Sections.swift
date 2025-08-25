//
//  Render+Sections.swift
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
                output.append("<div class=\"lines " + (section.environment.rawValue ?? "") + "\">")
                output.append(sectionStart(section))
                lyricsSection(output: &output, section: section, settings: settings)
                output.append("</div>")
                //LyricsSection(section: section, settings: settings)
                //            case .repeatChorus:
                //                RepeatChorusSection(
                //                    section: section,
                //                    sections: sections,
                //                    settings: settings
                //                )
                //            case .tab:
                //                if !settings.application.lyricsOnly {
                //                    TabSection(section: section, settings: settings)
                //                }
                //            case .grid:
                //                if !settings.application.lyricsOnly {
                //                    GridSection(section: section, settings: settings)
                //                }
                //            case .textblock:
                //                TextblockSection(section: section, settings: settings)
                //            case .comment:
                //                CommentSection(section: section, settings: settings)
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

    static private func sectionStart(_ section: Song.Section) -> String {

        var html = ""
        html += "<div class=\"section "
        if section.lines.isEmpty {
            html += "no-name\">&nbsp;</div><div class=\"section single "
        }
        if section.label == nil {
            html += "no-name "
        }
        html += (section.environment.rawValue)
        html += "\">"
        html += (!section.label.isEmpty ? "<div class=\"name\">" + section.label + "</div>" : "&nbsp;")
        html += "</div>"

        return html
    }


}
