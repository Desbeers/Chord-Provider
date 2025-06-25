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
    ///
    /// Display a line of a lyrics section of the song
    class Line: PDFElement {
        /// The parts in the line
        let parts: [Part]
        /// Bool if the width of the line should we deducted from the rect
        /// - Note: Used to calculate the widest line
        let deductWidthFromRect: Bool

        /// Init the **line** element
        /// - Parameters:
        ///   - parts: The parts of the line
        ///   - chords: All the chords from the song
        ///   - settings: The application settings
        ///   - deductWidthFromRect: Bool if the width of the line should we deducted from the rect
        init(parts: [Song.Section.Line.Part], chords: [ChordDefinition], settings: AppSettings, deductWidthFromRect: Bool = false) {
            var items: [Part] = []
            for part in parts {
                items.append(Part(part: part, chords: chords, settings: settings))
            }
            self.parts = items
            self.deductWidthFromRect = deductWidthFromRect
        }

        /// Draw the **line** element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            var maxHeight: CGFloat = 0
            var cellRect = rect
            for part in parts {

                part.draw(rect: &cellRect, calculationOnly: calculationOnly, pageRect: pageRect)

                maxHeight = max(maxHeight, rect.height - cellRect.height)

                cellRect.origin.y = rect.origin.y
                cellRect.size.height = rect.size.height
            }
            rect.origin.y += maxHeight
            rect.size.height -= maxHeight
            if deductWidthFromRect {
                rect.size.width = cellRect.size.width
            }
        }
    }
}
