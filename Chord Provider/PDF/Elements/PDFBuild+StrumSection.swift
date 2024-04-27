//
//  PDFBuild+StrumSection.swift
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

    /// A PDF strum section item
    open class StrumSection: PDFElement {

        let section: Song.Section

        init(_ section: Song.Section) {
            self.section = section
        }

        open override func draw(rect: inout CGRect, calculationOnly: Bool) {

            for line in section.lines {
                if line.comment.isEmpty {
                    for strum in line.strum {
                        let line = PDFBuild.Text(strum, attributes: .strumLine)
                        line.draw(rect: &rect, calculationOnly: calculationOnly)
                    }
                } else {
                    let comment = PDFBuild.Comment(line.comment).padding(6)
                    comment.draw(rect: &rect, calculationOnly: calculationOnly)
                }
            }
        }
    }
}

extension StringAttributes {

    /// String attributes for a strum line
    static var strumLine: StringAttributes {
        [
            .foregroundColor: SWIFTColor.black,
            .font: SWIFTFont.monospacedSystemFont(ofSize: 8, weight: .regular)
        ]
    }
}
