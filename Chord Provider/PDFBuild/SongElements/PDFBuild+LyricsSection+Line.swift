//
//  PDFBuild+LyricsSection+Line.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension PDFBuild.LyricsSection {

    // MARK: A PDF **line** element for a `LyricsSection`

    /// A PDF **line** element for a `LyricsSection`
    class Line: PDFElement {
        /// The parts in the line
        let parts: [Part]
        /// The height of a single part
        let height: CGFloat

        /// Init the **line** element
        /// - Parameters:
        ///   - parts: The parts of the line
        ///   - chords: All the chords from the song
        init(parts: [Song.Section.Line.Part], chords: [ChordDefinition]) {
            var items: [Part] = []
            for part in parts {
                items.append(Part(part: part, chords: chords))
            }
            self.parts = items
            self.height = items.first?.size.height ?? 0
        }

        /// Draw the **line** element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            var partOffset: CGFloat = 0
            for part in parts {
                var cellRect = CGRect(
                    x: rect.minX + partOffset,
                    y: rect.minY,
                    width: part.size.width,
                    height: part.size.height
                )
                partOffset += part.size.width
                /// Add a bit extra width if the text ends with a `space` and there are chords
                if !part.chords.isEmpty, part.text.string.last == " " {
                    partOffset += 2 * textPadding
                }
                part.draw(rect: &cellRect, calculationOnly: calculationOnly, pageRect: pageRect)
            }
            rect.origin.y += height
            rect.size.height -= height
        }
    }
}
