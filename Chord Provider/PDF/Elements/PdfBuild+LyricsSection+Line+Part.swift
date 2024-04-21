//
//  PdfBuild+LyricsSection+Line+Part.swift
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

extension PdfBuild.LyricsSection.Line {

    open class Part: PdfElement {

        let text: NSAttributedString
        let size: CGSize
        let padding: CGFloat = 2

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
                size.width += padding * 2
            }
            self.size = size
        }

        open override func draw(rect: inout CGRect) {
            PdfBuild.log(text.string)
            let textBounds = text.bounds(withSize: rect.size)
            let options: NSString.DrawingOptions = [
                /// Render the string in multiple lines
                .usesLineFragmentOrigin,
                .truncatesLastVisibleLine
            ]
            text.draw(with: rect, options: options, context: nil)
            let height = textBounds.height + 2 * padding
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
            .font: SWIFTFont.systemFont(ofSize: 10, weight: .regular),
        ]
    }

    static var partLyric: StringAttributes {
        [
            .foregroundColor: SWIFTColor.black,
            .font: SWIFTFont.systemFont(ofSize: 10, weight: .regular)
        ]
    }
}
