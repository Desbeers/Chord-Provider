//
//  PDFBuild+SongDetails.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation
import SwiftlyChordUtilities

extension PDFBuild {

    // MARK: A PDF **song details** element

    /// A PDF **song details** element
    class SongDetails: PDFElement {

        /// The ``Song``
        let song: Song

        /// Init the **song details** element
        /// - Parameter song: The ``Song``
        init(song: Song) {
            self.song = song
        }

        /// Draw the **song details** element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            /// Add the detail items
            var items: [NSAttributedString] = []
            items.append(detailLabel(icon: "􀑭", label: song.metaData.instrument.label))
            if let key = song.metaData.key {
                items.append(detailLabel(icon: "􀟕", label: key.displayName(options: .init())))
            }
            if let capo = song.metaData.capo {
                items.append(detailLabel(icon: "􀉢", label: capo))
            }
            if let time = song.metaData.time {
                items.append(detailLabel(icon: "􀐱", label: time))
            }
            let text = items.joined(with: "  ")
            /// Draw the details
            let textBounds = text.bounds(withSize: rect.size)
            if !calculationOnly {
                text.draw(with: rect, options: textDrawingOptions, context: nil)
            }
            let height = textBounds.height + 2 * textPadding
            rect.origin.y += height
            rect.size.height -= height
        }

        /// Make a detail label
        /// - Parameters:
        ///   - icon: The icon as `String`
        ///   - label: The label as `String`
        /// - Returns: An `NSAttributedString` with icon, label and attributes
        private func detailLabel(icon: String, label: String) -> NSAttributedString {
            [
                NSAttributedString(string: icon, attributes: .songDetailIcon),
                NSAttributedString(string: label, attributes: .songDetailLabel)
            ].joined(with: " ")
        }
    }
}

extension SWIFTStringAttribute {

    // MARK: Song Detail string styling

    /// String attributes for a song detail icon
    static var songDetailIcon: SWIFTStringAttribute {
        [
            .foregroundColor: SWIFTColor.gray,
            .font: SWIFTFont.systemFont(ofSize: 8, weight: .regular)
        ] + alignment(.center)
    }

    /// String attributes for a song detail label
    static var songDetailLabel: SWIFTStringAttribute {
        [
            .foregroundColor: SWIFTColor.black,
            .font: SWIFTFont.systemFont(ofSize: 8, weight: .regular)
        ] + alignment(.center)
    }
}
