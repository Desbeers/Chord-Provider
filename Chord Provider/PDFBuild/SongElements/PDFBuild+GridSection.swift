//
//  PDFBuild+GridSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import AppKit
import ChordProviderCore

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
            /// Convert the grid into columns
            let section = section.gridColumns()
            /// Draw the elements
            for line in section.lines {
                switch line.type {
                case .songLine:
                    if let gridColumns = line.gridColumns {
                        var lineHeight: Double = 0
                        var partRect = rect
                        for column in gridColumns.grids {
                            let string = NSMutableAttributedString()
                            for part in column.parts {
                                string.append(
                                    NSAttributedString(
                                        string: " \(part.text ?? "") \(part == column.parts.last ? "" : "\n")",
                                        attributes: part.chordDefinition == nil ? .gridText(settings: settings) : .gridChord(settings: settings)
                                    )
                                )
                            }
                            let textBounds = string.boundingRect(with: pageRect.size, options: .usesLineFragmentOrigin)
                            lineHeight = max(lineHeight, textBounds.height)
                            if !calculationOnly {
                                string.draw(in: partRect)
                            }
                            /// Move the rect
                            partRect.origin.y = rect.origin.y
                            partRect.origin.x += textBounds.width + 2 * textPadding
                        }
                        rect.origin.y += lineHeight
                        rect.size.height -= lineHeight
                    }
                case .emptyLine:
                    let spacer = PDFBuild.Spacer(settings.style.fonts.chord.size / 2)
                    spacer.draw(rect: &rect, calculationOnly: calculationOnly, pageRect: pageRect)
                case .comment:
                    let comment = PDFBuild.Comment(line.plain ?? "", settings: settings).padding(6)
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
