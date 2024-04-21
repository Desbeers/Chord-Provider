//
//  PdfBuild+GridSection.swift
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

extension PdfBuild {

    /// A PDF grid section item
    open class GridSection: PdfElement {

        let section: Song.Section
        let chords: [ChordDefinition]

        let padding: CGFloat = 2

        init(_ section: Song.Section, chords: [ChordDefinition]) {
            self.section = section
            self.chords = chords
        }

        open override func draw(rect: inout CGRect) {

            for line in section.lines {
                if line.comment.isEmpty {
                    //for grid in line.grid {
                    let line = PdfBuild.GridSection.Line(line.grid, chords: chords)
                        line.draw(rect: &rect)
                    //}
                } else {
                    let comment = PdfBuild.Comment(line.comment).padding(6)
                    comment.draw(rect: &rect)
                }
            }
        }
    }
}
