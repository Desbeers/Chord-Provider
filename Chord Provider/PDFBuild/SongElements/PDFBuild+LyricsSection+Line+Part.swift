//
//  PDFBuild+LyricsSection+Line+Part.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension PDFBuild.LyricsSection.Line {

    // MARK: A PDF **part** element for a `Line` in a `LyricsSection`

    /// A PDF **part** element for a `Line` in a `LyricsSection`
    ///
    /// Display a part of a line of a lyrics section of the song
    class Part: PDFElement {

        /// The chord of the part
        let chord: NSAttributedString?
        /// The text of the part
        let text: NSAttributedString
        /// All the chords of the ``Song``
        let chords: [ChordDefinition]

        /// Init the **part** element
        /// - Parameters:
        ///   - part: The part of the lyrics line
        ///   - chords: All the chords of the song
        ///   - settings: The application settings
        init(part: Song.Section.Line.Part, chords: [ChordDefinition], settings: AppSettings) {

            var fontOptions = settings.style.fonts.text
            fontOptions.color = settings.style.theme.foreground

            self.chords = chords
            /// Preserve spaces in the drawing
            let lyrics = "\u{200c}\(part.text ?? " ")\u{200c}"
            let text = lyrics.toMarkdown(fontOptions: fontOptions, scale: settings.pdf.scale)
            self.text = NSAttributedString(text)

            if !chords.isEmpty {
                var chordString: String = " "
                if let chord = part.chordDefinition {
                    chordString = chord.display
                }
                self.chord = NSAttributedString(
                    /// Add a space behind the chord-name so two chords will never 'stick' together
                    string: "\(chordString) ",
                    attributes: .attributes(settings.style.fonts.chord, scale: settings.pdf.scale)
                )
            } else {
                self.chord = nil
            }
        }

        /// Draw the **part** element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            /// The width of the part
            var width: Double = 0
            /// The size of the lyrics
            let textBounds = text.boundingRect(with: rect.size)
            if let chord {
                let textBounds = chord.boundingRect(with: rect.size)
                if !calculationOnly {
                    chord.draw(with: rect, options: textDrawingOptions, context: nil)
                }
                let height = textBounds.height + 2 * textPadding
                width = textBounds.width
                rect.origin.y += height
                rect.size.height -= height
            } else {
                /// I don't know why...
                rect.origin.y += textBounds.height * 0.5
                rect.size.height -= textBounds.height * 0.5
            }

            rect.origin.y += textBounds.height * 0.5
            rect.size.height -= textBounds.height * 0.5
            if !calculationOnly {
                text.draw(with: rect)
            }
            let height = (textBounds.height * 0.5)
            /// Remember the biggest width
            width = max(width, textBounds.width)
            /// Set the rect
            rect.origin.y += height
            rect.size.height -= height
            rect.origin.x += width
            rect.size.width -= width
        }
    }
}
