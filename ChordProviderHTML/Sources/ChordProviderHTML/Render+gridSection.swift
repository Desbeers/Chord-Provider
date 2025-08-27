//
//  File.swift
//  ChordProviderHTML
//
//  Created by Nick Berendsen on 26/08/2025.
//

import Foundation
import ChordProviderCore

extension   HtmlRender {

    static func gridSection(output: inout [String], section: Song.Section, settings: HtmlSettings) {

        let maxColumns = section.lines.compactMap { $0.grid }.reduce(0) { accumulator, grids in
            let elements = grids.flatMap { $0.parts }.count
            return max(accumulator, elements)
        }

        var elements: [String] = (0 ..< maxColumns).map { _ in String() }

        for line in section.lines where line.type == .songLine {
            if let grid = line.grid {
                let parts = grid.flatMap { $0.parts }
                for (column, part) in parts.enumerated() {
                    elements[column].append("<div>\(part.text ?? "&nbsp;")</div>")
                }
            }
        }

        let result = elements.map {element in
            return "<div class=\"part\">\(element)</div>"
        }

        output.append(wrapSongSection(section: section, content: result, settings: settings))
    }
}
