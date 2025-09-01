//
//  Render+gridSection.swift
//  ChordProviderHTML
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension HtmlRender {

    static func gridSection(output: inout [String], section: Song.Section, settings: HtmlSettings) {
        /// Convert the grid into columns
        var section = section.gridColumns()
        var result: [String] = []
        for line in section.lines {
            switch line.type {
            case .songLine:
                result.append("<div class=\"line\">")
                if let gridColumns = line.gridColumns {
                    for column in gridColumns.grids {
                        let parts = column.parts.map { part in
                            if let chordDefinition = part.chordDefinition, let text = part.text {
                                return "<div class=\"chord\">\(chordDefinition.display)</div>"
                            } else if let text = part.text {
                                return "<div>\(text.isEmpty ? "&nbsp;" : "\(text)")</div>"
                            }
                            /// This should not happen
                            return ""
                        }
                        result.append("<div class=\"part\">\(parts.joined())</div>")
                    }
                }
                result.append("</div>")
            case .emptyLine:
                result.append("<div class=\"line\">&nbsp;</div>")
            case .comment:
                commentLabel(output: &result, comment: line.plain, inline: true, settings: settings)
            default:
                break
            }
        }
        output.append(wrapSongSection(section: section, content: result, settings: settings))
    }
}
