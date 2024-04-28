//
//  PDFBuild+TabSection.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation
import SwiftlyChordUtilities

extension PDFBuild {

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
        func draw(rect: inout CGRect, calculationOnly: Bool) {
            for line in section.lines {
                if line.comment.isEmpty {
                    let line = PDFBuild.TabSection.Line(line.tab)
                    line.draw(rect: &rect, calculationOnly: calculationOnly)
                } else {
                    let comment = PDFBuild.Comment(line.comment).padding(6)
                    comment.draw(rect: &rect, calculationOnly: calculationOnly)
                }
            }
        }
    }
}
