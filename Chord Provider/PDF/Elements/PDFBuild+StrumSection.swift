//
//  PDFBuild+StrumSection.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation

extension PDFBuild {

    /// A PDF **strum section** element
    class StrumSection: PDFElement {

        /// The section with strumming
        let section: Song.Section

        /// Init the **strum section** element
        /// - Parameter section: The section with strumming
        init(_ section: Song.Section) {
            self.section = section
        }

        /// Draw the **strum section** element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        func draw(rect: inout CGRect, calculationOnly: Bool) {
            for line in section.lines {
                if line.comment.isEmpty {
                    for strum in line.strum {
                        let line = PDFBuild.Text(strum, attributes: .strumLine)
                        line.draw(rect: &rect, calculationOnly: calculationOnly)
                    }
                } else {
                    let comment = PDFBuild.Comment(line.comment).padding(6)
                    comment.draw(rect: &rect, calculationOnly: calculationOnly)
                }
            }
        }
    }
}

extension StringAttributes {

    /// String attributes for a strum line
    static var strumLine: StringAttributes {
        [
            .foregroundColor: SWIFTColor.black,
            .font: SWIFTFont.monospacedSystemFont(ofSize: 8, weight: .regular)
        ]
    }
}
