//
//  PDFBuild+GridSection.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation
import SwiftlyChordUtilities

extension PDFBuild {

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
        func draw(rect: inout CGRect, calculationOnly: Bool) {

            for line in section.lines {
                if line.comment.isEmpty {
                    let line = PDFBuild.GridSection.Line(line.grid, chords: chords)
                    line.draw(rect: &rect, calculationOnly: calculationOnly)
                } else {
                    let comment = PDFBuild.Comment(line.comment).padding(6)
                    comment.draw(rect: &rect, calculationOnly: calculationOnly)
                }
            }
        }
    }
}
