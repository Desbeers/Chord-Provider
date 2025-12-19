//
//  PDFBuild+StrumSection+Line.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension PDFBuild.StrumSection {

    // MARK: A PDF **line** element for a `StrumSection`

    /// A PDF **line** element for a `StrumSection`
    ///
    /// Display a line of a strum section of the song
    class Line: PDFElement {
        /// The strums in the line
        let parts: [Part]
        /// The height of a single part
        let height: CGFloat

        /// Init the **line** element
        /// - Parameters:
        ///   - strums: The strums in the line
        ///   - settings: The application settings
        init(strums: [Song.Section.Line.Strums], settings: AppSettings) {
            var items: [Part] = []
            let spacer = Song.Section.Line.Strum(id: 0, action: .none, beat: " ", tuplet: " ")
            for strum in strums {
                for part in strum.strums {
                    items.append(Part(part: part, settings: settings))
                }
                items.append(Part(part: spacer, settings: settings))
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
                part.draw(rect: &cellRect, calculationOnly: calculationOnly, pageRect: pageRect)
            }
            rect.origin.y += height
            rect.size.height -= height
        }
    }
}
