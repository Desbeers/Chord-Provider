//
//  PDFBuild+LyricsSection.swift
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

    /// A PDF lyrics section item
    open class LyricsSection: PDFElement {

        let section: Song.Section
        let chords: [ChordDefinition]

        init(_ section: Song.Section, chords: [ChordDefinition]) {
            self.section = section
            self.chords = chords
        }

        open override func draw(rect: inout CGRect, calculationOnly: Bool) {

            for line in section.lines {
                if line.comment.isEmpty {
                    let line = Line(parts: line.parts, chords: chords)
                    line.draw(rect: &rect, calculationOnly: calculationOnly)
                } else {
                    let comment = PDFBuild.Comment(line.comment).padding(6)
                    comment.draw(rect: &rect, calculationOnly: calculationOnly)
                }
            }
        }
    }
}

extension StringAttributes {

//    /// String attributes for a strum line
//    static var strumLine: StringAttributes {
//        [
//            .foregroundColor: SWIFTColor.black,
//            .font: SWIFTFont.monospacedSystemFont(ofSize: 8, weight: .regular)
//        ]
//    }
}
