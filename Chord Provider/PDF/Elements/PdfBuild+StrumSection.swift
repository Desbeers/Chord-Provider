//
//  PdfBuild+StrumSection.swift
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

    /// A PDF strum section item
    open class StrumSection: PdfElement {

        let section: Song.Section

        let padding: CGFloat = 2

        init(_ section: Song.Section) {
            self.section = section
        }

        open override func draw(rect: inout CGRect) {

            for line in section.lines {
                if line.comment.isEmpty {
                    for strum in line.strum {
                        let line = PdfBuild.Text(strum, attributes: .strumLine)
                        line.draw(rect: &rect)
                    }
                } else {
                    let comment = PdfBuild.Comment(line.comment).padding(6)
                    comment.draw(rect: &rect)
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
