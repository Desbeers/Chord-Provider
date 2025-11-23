//
//  Render+gridSection.swift
//  ChordProviderHTML
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension HtmlRender {

    static func gridSection(output: inout [String], section: Song.Section, settings: ChordProviderSettings) {
        /// Convert the grid into columns
        let section = section.gridColumns()
        var result: [String] = []
        for line in section.lines {
            switch line.type {
            case .songLine:
                result.append("<div class=\"line\">")
                if let gridColumns = line.gridColumns {
                    for column in gridColumns.grids {
                        let parts = column.cells.map { cell in
                            for part in cell.parts {
                                if let chordDefinition = part.chordDefinition {
                                    return "<div class=\"chord\">\(chordDefinition.display)</div>"
                                } else if let strum = part.strum {
                                    return "<div>\(strum.symbol)</div>"
                                } else if let text = part.text {
                                    dump(text)
                                    return "<div>\(text == " " ? "&nbsp;" : "\(text)")</div>"
                                }
                            }
                            /// This should not happen
                            return "<div>&nbsp;</div>"
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
