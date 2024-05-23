//
//  PDFBuild+LyricsSection.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation
import SwiftlyChordUtilities

extension PDFBuild {

    /// A PDF **lyrics section** element
    class LyricsSection: PDFElement {

        /// The section with lyrics
        let section: Song.Section
        /// All the chords from the song
        let chords: [ChordDefinition]

        /// Init the **lyrics section** element
        /// - Parameters:
        ///   - section: The section with lyrics
        ///   - chords: All the chords from the song
        init(_ section: Song.Section, chords: [ChordDefinition]) {
            self.section = section
            self.chords = chords
        }

        /// Draw the **lyrics section** element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            for line in section.lines {
                if line.comment.isEmpty {
                    let line = Line(parts: line.parts, chords: chords)
                    line.draw(rect: &rect, calculationOnly: calculationOnly, pageRect: pageRect)
                } else {
                    let comment = PDFBuild.Comment(line.comment).padding(6)
                    comment.draw(rect: &rect, calculationOnly: calculationOnly, pageRect: pageRect)
                }
            }
        }
    }
}
