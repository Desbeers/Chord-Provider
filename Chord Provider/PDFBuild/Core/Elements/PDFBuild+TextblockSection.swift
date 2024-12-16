//
//  PDFBuild+TextblockSection.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import AppKit

extension PDFBuild {

    // MARK: A PDF **textblock section** element

    /// A PDF **textblock section** element
    class TextblockSection: PDFElement {

        /// The section with textblock
        let section: Song.Section

        /// Init the **textblock section** element
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
                if let parts = line.parts {
                    for part in parts {
                        let line = PDFBuild.Text(part.text, attributes: .textblockLine + .alignment(PDFBuild.getAlign(section.arguments)))
                        line.draw(rect: &rect, calculationOnly: calculationOnly, pageRect: pageRect)
                    }
                }
            }
        }
    }
}

extension PDFStringAttribute {

    // MARK: Textblock string styling

    /// String attributes for a textblock  line
    static var textblockLine: PDFStringAttribute {
        /// Set the fallback font
        let systemFont = NSFont.systemFont(ofSize: 10)
        /// Create a font descriptor with the italic trait
        let fontDescriptor = systemFont.fontDescriptor.withSymbolicTraits(.italic)
        /// Create a font from the descriptor
        let italicSystemFont = NSFont(descriptor: fontDescriptor, size: 10) ?? systemFont
        /// Return italic font or fallback to system font
        return [
            .foregroundColor: NSColor.gray,
            .font: italicSystemFont
        ]
    }
}
