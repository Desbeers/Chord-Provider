//
//  PDFBuild+PlainSection.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import AppKit

extension PDFBuild {

    // MARK: A PDF **plain section** element

    /// A PDF **plain section** element
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
                if let parts = line.parts {
                    for part in parts {
                        let line = PDFBuild.Text(part.text, attributes: .plainLine)
                        line.draw(rect: &rect, calculationOnly: calculationOnly, pageRect: pageRect)
                    }
                }
            }
        }
    }
}

extension PDFStringAttribute {

    // MARK: Plain line string styling

    /// String attributes for a plain line
    static var plainLine: PDFStringAttribute {
        [
            .foregroundColor: NSColor.gray,
            .font: NSFont.systemFont(ofSize: 10, weight: .regular)
        ]
    }
}
