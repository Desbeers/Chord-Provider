//
//  PDFBuild+GridSection.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif
import SwiftlyChordUtilities

extension PDFBuild {

    /// A PDF grid section item
    open class GridSection: PDFElement {

        let section: Song.Section
        let chords: [ChordDefinition]

        init(_ section: Song.Section, chords: [ChordDefinition]) {
            self.section = section
            self.chords = chords
        }

        open override func draw(rect: inout CGRect, calculationOnly: Bool) {

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
