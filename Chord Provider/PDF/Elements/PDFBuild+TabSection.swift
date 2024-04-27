//
//  PDFBuild+TabSection.swift
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

    /// A PDF tab section item
    open class TabSection: PDFElement {

        let section: Song.Section

        init(_ section: Song.Section) {
            self.section = section
        }

        open override func draw(rect: inout CGRect, calculationOnly: Bool) {

            for line in section.lines {
                if line.comment.isEmpty {
                    let line = PDFBuild.TabSection.Line(line.tab)
                    line.draw(rect: &rect, calculationOnly: calculationOnly)
                } else {
                    let comment = PDFBuild.Comment(line.comment).padding(6)
                    comment.draw(rect: &rect, calculationOnly: calculationOnly)
                }
            }
        }
    }
}
