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
                    let line = PdfBuild.Text(part.text)
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
            .foregroundColor: SWIFTColor.red,
            .font: SWIFTFont.systemFont(ofSize: 8, weight: .regular)
        ]
    }
}
