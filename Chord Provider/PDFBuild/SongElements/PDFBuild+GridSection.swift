//
//  PDFBuild+GridSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension PDFBuild {

    // MARK: A PDF **grid section** element

    /// A PDF **grid section** element
    ///
    /// Display a grid section of the song
    class GridSection: PDFElement {

        /// The section with grids
        let section: Song.Section
        /// All the chords from the song
        let chords: [ChordDefinition]
        /// The application settings
        let settings: AppSettings

        /// Init the **grid section** element
        /// - Parameters:
        ///   - section: The section with grids
        ///   - chords: All the chords from the song
        ///   - settings: The application settings
        init(_ section: Song.Section, chords: [ChordDefinition], settings: AppSettings) {
            self.section = section
            self.chords = chords
            self.settings = settings
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
                                    attributes: .gridChord(settings: settings)
                                )
                            )
                        }
                        if !part.text.isEmpty {
                            elements[column].append(
                                NSAttributedString(
                                    string: "\(part.text)" + (line == lines.last ? "" : "\n"),
                                    attributes: .gridText(settings: settings)
                                )
                            )
                        }
                        if line != lines.last, part == parts.last, column < maxColumns {
                            for index in (column + 1)..<maxColumns {
                                elements[index].append(
                                    NSAttributedString(
                                        string: "\n",
                                        attributes: .gridText(settings: settings)
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
    static func gridText(settings: AppSettings) -> PDFStringAttribute {
        let font = NSFont(
            name: settings.style.fonts.text.font,
            size: settings.style.fonts.chord.size
        ) ?? .systemFont(ofSize: settings.style.fonts.chord.size)
        return [
            .foregroundColor: NSColor(settings.style.theme.foreground),
            .font: font
        ]
    }
    /// String attributes for a grid chord
    static func gridChord(settings: AppSettings) -> PDFStringAttribute {
        let font = settings.style.fonts.chord.nsFont(scale: 1)
        return [
            .foregroundColor: NSColor(settings.style.fonts.chord.color),
            .font: font
        ]
    }
}
