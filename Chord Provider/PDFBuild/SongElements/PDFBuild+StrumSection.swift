//
//  PDFBuild+StrumSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import AppKit

extension PDFBuild {

    // MARK: A PDF **strum section** element

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
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            for line in section.lines {
                switch line.directive {
                case .environmentLine:
                    if let strums = line.strum {
                        for strum in strums {
                            let line = PDFBuild.Text(strum, attributes: .strumLine)
                            line.draw(rect: &rect, calculationOnly: calculationOnly, pageRect: pageRect)
                        }
                    }
                case .comment:
                    let comment = PDFBuild.Comment(line.label).padding(6)
                    comment.draw(rect: &rect, calculationOnly: calculationOnly, pageRect: pageRect)
                default:
                    break
                }
            }
        }
    }
}

extension PDFStringAttribute {

    // MARK: Strum string styling

    /// String attributes for a strum line
    static var strumLine: PDFStringAttribute {
        [
            .foregroundColor: NSColor.black,
            .font: NSFont.monospacedSystemFont(ofSize: 8, weight: .regular)
        ]
    }
}
