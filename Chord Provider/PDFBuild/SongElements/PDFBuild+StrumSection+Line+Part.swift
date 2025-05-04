//
//  PDFBuild+StrumSection+Line+Part.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension PDFBuild.StrumSection.Line {

    // MARK: A PDF **part** element for a `Line` in a `StrumSection`

    /// A PDF **part** element for a `Line` in a `StrumSection`
    ///
    /// Display a part of a line of a strum section of the song
    class Part: PDFElement {

        /// The text of the part
        /// - Note: A merge of the optional chord and optional lyrics part
        let text = NSMutableAttributedString()
        /// The size of the part
        /// - Note: Used by the `Line` element to define the rectangle
        let size: CGSize
        /// The application settings
        let settings: AppSettings

        /// Init the **part** element
        /// - Parameters:
        ///   - part: The part of the strum line
        ///   - settings: The application settings
        init(part: Song.Section.Line.Strum, settings: AppSettings) {
            self.text.append(
                NSAttributedString(
                    string: "\(part.strum)\n",
                    attributes: .strumLine(settings: settings)
                )
            )
            self.text.append(
                NSAttributedString(
                    string: "\(part.beat.isEmpty ? part.tuplet : part.beat)",
                    attributes: .strumLineBeat(settings: settings)
                )
            )
            self.settings = settings
            self.size = text.size()
        }

        /// Draw the **part** element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            let textBounds = text.boundingRect(with: rect.size)
            if !calculationOnly {
                text.draw(with: rect, options: textDrawingOptions, context: nil)
            }
            let height = textBounds.height + 2 * textPadding
            rect.origin.y += height
            rect.size.height -= height
        }
    }
}
