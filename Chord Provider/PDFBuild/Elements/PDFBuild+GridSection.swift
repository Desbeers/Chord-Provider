//
//  PDFBuild+GridSection.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation
import SwiftlyChordUtilities

extension PDFBuild {

    // MARK: A PDF **grid section** element

    /// A PDF **grid section** element
    class GridSection: PDFElement {

        /// The section with grids
        let section: Song.Section
        /// All the chords from the song
        let chords: [ChordDefinition]

        /// Init the **grid section** element
        /// - Parameters:
        ///   - section: The section with grids
        ///   - chords: All the chords from the song
        init(_ section: Song.Section, chords: [ChordDefinition]) {
            self.section = section
            self.chords = chords
        }

        /// Draw the **grid section** element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {

            for line in section.lines {
                if line.comment.isEmpty {
                    let line = PDFBuild.GridSection.Line(line.grid, chords: chords)
                    line.draw(rect: &rect, calculationOnly: calculationOnly, pageRect: pageRect)
                } else {
                    let comment = PDFBuild.Comment(line.comment).padding(6)
                    comment.draw(rect: &rect, calculationOnly: calculationOnly, pageRect: pageRect)
                }
            }
        }
    }
}
