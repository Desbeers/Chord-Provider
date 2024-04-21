//
//  PdfBuild+PlainSection.swift
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

    /// A PDF plain section item
    open class PlainSection: PdfElement {

        let section: Song.Section

        init(_ section: Song.Section) {
            self.section = section
        }

        open override func draw(rect: inout CGRect) {
            for line in section.lines {
                for part in line.parts {
                    let line = PdfBuild.Text(part.text, attributes: .plainLine)
                    line.draw(rect: &rect)
                }
            }
        }
    }
}

// MARK: Plain line string styling

extension StringAttributes {

    static var plainLine: StringAttributes {
        [
            .foregroundColor: SWIFTColor.gray,
            .font: SWIFTFont.systemFont(ofSize: 10, weight: .regular)
        ]
    }
}
