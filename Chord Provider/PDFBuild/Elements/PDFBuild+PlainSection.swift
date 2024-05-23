//
//  PDFBuild+PlainSection.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension PDFBuild {

    /// A PDF *plain section* element
    class PlainSection: PDFElement {

        /// The plain section
        let section: Song.Section

        /// Init the **plain section** element
        /// - Parameter section: The plain section
        init(_ section: Song.Section) {
            self.section = section
        }

        /// Draw the **plain section** element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            for line in section.lines {
                for part in line.parts {
                    let line = PDFBuild.Text(part.text, attributes: .plainLine)
                    line.draw(rect: &rect, calculationOnly: calculationOnly, pageRect: pageRect)
                }
            }
        }
    }
}

// MARK: Plain line string styling

extension StringAttributes {

    static var plainLine: StringAttributes {
        [
            .foregroundColor: SWIFTColor.gray,
            .font: SWIFTFont.systemFont(ofSize: 10, weight: .regular)
        ]
    }
}
