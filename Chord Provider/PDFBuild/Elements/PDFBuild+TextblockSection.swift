//
//  PDFBuild+TextblockSection.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension PDFBuild {

    // MARK: A PDF **textblock section** element

    /// A PDF **textblock section** element
    class TextblockSection: PDFElement {

        /// The section with textblock
        let section: Song.Section

        /// Ini the **textblock section** element
        /// - Parameter section: The section with textblock
        init(_ section: Song.Section) {
            self.section = section
        }

        /// Draw the **textblock section** element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            for line in section.lines {
                for part in line.parts {
                    let line = PDFBuild.Text(part.text, attributes: .textblockLine)
                    line.draw(rect: &rect, calculationOnly: calculationOnly, pageRect: pageRect)
                }
            }
        }
    }
}

extension SWIFTStringAttribute {

    // MARK: Textblock string styling

    /// String attributes for a textblock  line
    static var textblockLine: SWIFTStringAttribute {
        [
            .foregroundColor: SWIFTColor.gray,
            .font: SWIFTFont.italicSystemFont(ofSize: 10)
        ]
    }
}
