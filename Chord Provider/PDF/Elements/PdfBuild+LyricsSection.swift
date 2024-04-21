//
//  PdfBuild+LyricsSection.swift
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

    /// A PDF lyrics section item
    open class LyricsSection: PdfElement {

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
                    //for part in line.parts {
                    let line = Line(parts: line.parts, chords: chords)
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

extension StringAttributes {

//    /// String attributes for a strum line
//    static var strumLine: StringAttributes {
//        [
//            .foregroundColor: SWIFTColor.black,
//            .font: SWIFTFont.monospacedSystemFont(ofSize: 8, weight: .regular)
//        ]
//    }
}
