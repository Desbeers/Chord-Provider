//
//  File.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension GtkRender {

    struct GridSection: View {
        /// An identifiable wrapper
        struct Element: Identifiable {
            struct Item: Identifiable {
                var id: Int
                var description: String

            }
            init(id: Int = 0, text: [Item] = []) {
                self.id = id
                self.text = text
            }
            let id: Int
            var text: [Item]
        }
        /// Init the struct
        init(section: Song.Section, settings: AppSettings) {
            let maxColumns = section.lines.compactMap { $0.grid }.reduce(0) { accumulator, grids in
                let elements = grids.flatMap { $0.parts }.count
                return max(accumulator, elements)
            }
            var elements: [Element] = (0 ..< maxColumns).map { _ in Element() }
            for line in section.lines where line.type == .songLine {
                if let grid = line.grid {
                    let parts = grid.flatMap { $0.parts }
                    for (column, part) in parts.enumerated() {
                        var text = part.text ?? ""
                        if let chord = part.chordDefinition {
                            text = "<span foreground='#0433ff'>\(chord.display)</span>"
                        }
                        elements[column].text.append(Element.Item(id: part.id, description: text))
                    }
                }
            }
            self.elements = elements
            self.settings = settings
        }
        let elements: [GridSection.Element]
        let settings: AppSettings
        var view: Body {
            VStack {
                ForEach(elements, horizontal: true) { element in
                    HStack {
                        ForEach(element.text) { text in
                            Text(text.description)
                                .useMarkup()
                                .halign(.start)
                                .padding(5, .trailing)
                        }
                    }
                }
            }
            .padding(10)
        }
    }
}
