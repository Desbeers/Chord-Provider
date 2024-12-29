//
//  PDFBuild+TabSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension PDFBuild {

    // MARK: A PDF **tab section** element

    /// A PDF **tab section** element
    class TabSection: PDFElement {

        /// The section with tabs
        let section: Song.Section

        /// Init the **tab section** element
        /// - Parameter section: The section with tabs
        init(_ section: Song.Section) {
            self.section = section
        }

        /// Draw the **lyrics section** element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            for line in section.lines {
                switch line.directive {
                case .environmentLine:
                    let line = PDFBuild.TabSection.Line(line.label)
                    line.draw(rect: &rect, calculationOnly: calculationOnly, pageRect: pageRect)
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
