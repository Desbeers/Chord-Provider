//
//  PdfBuild+TabSection.swift
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

    /// A PDF tab section item
    open class TabSection: PdfElement {

        let section: Song.Section

        let padding: CGFloat = 2

        init(_ section: Song.Section) {
            self.section = section
        }

        open override func draw(rect: inout CGRect) {

            for line in section.lines {
                if line.comment.isEmpty {
                    let line = PdfBuild.TabSection.Line(line.tab)
                    line.draw(rect: &rect)
                } else {
                    let comment = PdfBuild.Comment(line.comment).padding(6)
                    comment.draw(rect: &rect)
                }
            }
        }
    }
}
