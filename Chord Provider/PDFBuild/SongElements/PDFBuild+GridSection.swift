//
//  PDFBuild+GridSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import AppKit

extension PDFBuild {

    // MARK: A PDF **grid section** element

    /// A PDF **grid section** element
    class GridSection: PDFElement {

        /// The section with grids
        let section: Song.Section
        /// All the chords from the song
        let chords: [ChordDefinition]

        /// Init the **grid section** element
        /// - Parameters:
        ///   - section: The section with grids
        ///   - chords: All the chords from the song
        init(_ section: Song.Section, chords: [ChordDefinition]) {
            self.section = section
            self.chords = chords
        }

        /// Draw the **grid section** element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            let lines = section.lines.filter { $0.directive == .environmentLine }
            let maxColumns = lines.compactMap { $0.grid }.reduce(0) { accumulator, grids in
                let elements = grids.flatMap { $0.parts }.count
                return max(accumulator, elements)
            }
            let elements: [NSMutableAttributedString] = (0 ..< maxColumns).map { _ in NSMutableAttributedString() }

            for line in lines {
                if let grid = line.grid {
                    let parts = grid.flatMap { $0.parts }
                    for (column, part) in parts.enumerated() {
                        if let chord = part.chord, let first = chords.first(where: { $0.id == chord }) {
                            elements[column].append(
                                NSAttributedString(
                                    string: "\(first.display)" + (line == lines.last ? "" : "\n"),
                                    attributes: .gridChord
                                )
                            )
                        }
                        if !part.text.isEmpty {
                            elements[column].append(
                                NSAttributedString(
                                    string: "\(part.text)" + (line == lines.last ? "" : "\n"),
                                    attributes: .gridText
                                )
                            )
                        }
                        if line != lines.last, part == parts.last, column < maxColumns {
                            for index in (column + 1)..<maxColumns {
                                elements[index].append(
                                    NSAttributedString(
                                        string: "\n",
                                        attributes: .gridText
                                    )
                                )
                            }
                        }
                    }
                }
            }
            var height: Double = 0.0
            for element in elements {
                let textRect = rect.insetBy(dx: textPadding, dy: textPadding)
                let textBounds = element.boundingRect(with: rect.size, options: .usesLineFragmentOrigin)
                height = max(height, textBounds.height + 2 * textPadding)
                if !calculationOnly {
                    element.draw(with: textRect, options: textDrawingOptions, context: nil)
                }
                let width = textBounds.width + 2 * textPadding
                rect.origin.x += width
                rect.size.width -= width
            }
            rect.origin.y += height
            rect.size.height -= height
        }
    }
}

extension PDFStringAttribute {

    // MARK: Grid string styling

    /// String attributes for a grid line
    static var gridText: PDFStringAttribute {
        [
            .foregroundColor: NSColor.black,
            .font: NSFont.monospacedSystemFont(ofSize: 10, weight: .regular)
        ]
    }
    /// String attributes for a grid chord
    static var gridChord: PDFStringAttribute {
        [
            .foregroundColor: NSColor.gray,
            .font: NSFont.monospacedSystemFont(ofSize: 10, weight: .regular)
        ]
    }
}
