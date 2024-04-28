//
//  PDFBuild+TextblockSection.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation

extension PDFBuild {

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
        func draw(rect: inout CGRect, calculationOnly: Bool) {
            for line in section.lines {
                for part in line.parts {
                    let line = PDFBuild.Text(part.text, attributes: .textblockLine)
                    line.draw(rect: &rect, calculationOnly: calculationOnly)
                }
            }
        }
    }
}

// MARK: Textblock string styling

extension StringAttributes {

    static var textblockLine: StringAttributes {
        [
            .foregroundColor: SWIFTColor.gray,
            .font: SWIFTFont.italicSystemFont(ofSize: 10)
        ]
    }
}
