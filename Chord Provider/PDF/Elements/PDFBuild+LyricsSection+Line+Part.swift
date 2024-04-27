//
//  PDFBuild+LyricsSection+Line+Part.swift
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

extension PDFBuild.LyricsSection.Line {

    open class Part: PDFElement {

        let text: NSAttributedString
        let size: CGSize

        init(part: Song.Section.Line.Part, chords: [ChordDefinition]) {
            var chordString: String = " "
            if let chord = chords.first(where: { $0.id == part.chord }) {
                chordString = chord.displayName(options: .init())
            }
            self.text =
            [
                NSAttributedString(
                    /// Add a space behind the chordname so two chords will never 'stick' together
                    string: "\(chordString) ",
                    attributes: .partChord),
                NSAttributedString(
                    string: "\(part.text)",
                    attributes: .partLyric)
            ]
                .joined(with: "\n")
            var size = self.text.size()

            /// Add a bit extra width if the text ends with a `space`
            if text.string.last == " " {
                size.width += 2 * PDFElement.textPadding
            }
            self.size = size
        }

        open override func draw(rect: inout CGRect, calculationOnly: Bool) {
            let textBounds = text.bounds(withSize: rect.size)
            if !calculationOnly {
                text.draw(with: rect, options: textDrawingOptions, context: nil)
            }
            let height = textBounds.height + 2 * PDFElement.textPadding
            rect.origin.y += height
            rect.size.height -= height
        }
    }
}

// MARK: Part string styling

public extension StringAttributes {

    static var partChord: StringAttributes {
        [
            .foregroundColor: SWIFTColor.gray,
            .font: SWIFTFont.systemFont(ofSize: 10, weight: .regular)
        ]
    }

    static var partLyric: StringAttributes {
        [
            .foregroundColor: SWIFTColor.black,
            .font: SWIFTFont.systemFont(ofSize: 10, weight: .regular)
        ]
    }
}
