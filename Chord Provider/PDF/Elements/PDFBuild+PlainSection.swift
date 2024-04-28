//
//  PDFBuild+PlainSection.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
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
        func draw(rect: inout CGRect, calculationOnly: Bool) {
            for line in section.lines {
                for part in line.parts {
                    let line = PDFBuild.Text(part.text, attributes: .plainLine)
                    line.draw(rect: &rect, calculationOnly: calculationOnly)
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
