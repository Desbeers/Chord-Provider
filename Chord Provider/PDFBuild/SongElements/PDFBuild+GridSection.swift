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
        /// The application settings
        let settings: AppSettings

        /// Init the **grid section** element
        /// - Parameters:
        ///   - section: The section with grids
        ///   - chords: All the chords from the song
        ///   - settings: The application settings
        init(_ section: Song.Section, settings: AppSettings) {
            self.section = section
            self.settings = settings
        }

        /// Draw the **grid section** element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            let maxColumns = section.lines.compactMap { $0.grid }.reduce(0) { accumulator, grids in
                let elements = grids.flatMap { $0.parts }.count
                return max(accumulator, elements)
            }
            /// Find the  column width
            let elements: [NSMutableAttributedString] = (0 ..< maxColumns).map { _ in NSMutableAttributedString() }
            var columnWidth: [Double] = (0 ..< maxColumns).map { _ in Double() }
            var lineHeight: Double = 0
            for line in section.lines where line.environment == .grid {
                if let grid = line.grid {
                    let parts = grid.flatMap { $0.parts }
                    for (column, part) in parts.enumerated() {
                        elements[column].append(
                            NSAttributedString(
                                string: " \(part.text) \n",
                                attributes: part.chord == nil ? .gridText(settings: settings) : .gridChord(settings: settings)
                            )
                        )
                        let textBounds = elements[column].boundingRect(with: rect.size, options: .usesLineFragmentOrigin)
                        columnWidth[column] = textBounds.width
                    }
                }
            }
            /// Draw the elements
            for line in section.lines {
                switch line.directive {
                case .environmentLine:
                    if let grid = line.grid {

                        var partRect = rect

                        let parts = grid.flatMap { $0.parts }
                        for (column, part) in parts.enumerated() {

                            let string = NSAttributedString(
                                string: " \(part.text) \u{200c}",
                                attributes: part.chord == nil ? .gridText(settings: settings) : .gridChord(settings: settings)
                            )
                            let textBounds = string.boundingRect(with: rect.size, options: .usesLineFragmentOrigin)
                            lineHeight = max(lineHeight, textBounds.height)
                            if !calculationOnly {
                                string.draw(in: partRect)
                                partRect.origin.y = rect.origin.y
                                partRect.origin.x += columnWidth[column] + 2 * textPadding
                            }
                        }
                        rect.origin.y += lineHeight
                        rect.size.height -= lineHeight
                    }
                case .emptyLine:
                    let spacer = PDFBuild.Spacer(settings.style.fonts.chord.size / 2)
                    spacer.draw(rect: &rect, calculationOnly: calculationOnly, pageRect: pageRect)
                case .comment:
                    let comment = PDFBuild.Comment(line.plain, settings: settings).padding(6)
                    comment.draw(rect: &rect, calculationOnly: calculationOnly, pageRect: pageRect)
                default:
                    break
                }
            }
        }
    }
}

extension PDFStringAttribute {

    // MARK: Grid string styling

    /// String attributes for a grid line
    static func gridText(settings: AppSettings) -> PDFStringAttribute {
        let font = NSFont(
            name: settings.style.fonts.text.font.postScriptName,
            size: settings.style.fonts.chord.size
        ) ?? .systemFont(ofSize: settings.style.fonts.chord.size)
        return [
            .foregroundColor: settings.style.fonts.text.color.nsColor,
            .font: font
        ]
    }
    /// String attributes for a grid chord
    static func gridChord(settings: AppSettings) -> PDFStringAttribute {
        let font = settings.style.fonts.chord.nsFont(scale: 1)
        return [
            .foregroundColor: settings.style.fonts.chord.color.nsColor,
            .font: font
        ]
    }
}
