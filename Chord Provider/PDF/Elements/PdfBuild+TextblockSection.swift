//
//  PdfBuild+TextblockSection.swift
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

    /// A PDF textblock section item
    open class TextblockSection: PdfElement {

        let section: Song.Section

        init(_ section: Song.Section) {
            self.section = section
        }

        open override func draw(rect: inout CGRect) {
            for line in section.lines {
                for part in line.parts {
                    let line = PdfBuild.Text(part.text, attributes: .textblockLine)
                    line.draw(rect: &rect)
                }
            }
        }
    }
}

// MARK: Textblock string styling

extension StringAttributes {

    static var textblockLine: StringAttributes {
        [
            .foregroundColor: SWIFTColor.gray,
            .font: SWIFTFont.italicSystemFont(ofSize: 10)
        ]
    }
}
