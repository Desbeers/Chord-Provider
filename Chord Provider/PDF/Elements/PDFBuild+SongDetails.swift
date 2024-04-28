//
//  PDFBuild+SongDetails.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation
import SwiftlyChordUtilities

extension PDFBuild {

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
        func draw(rect: inout CGRect, calculationOnly: Bool) {
            /// Add the detail items
            var items: [NSAttributedString] = []
            items.append(detailLabel(icon: "􀑭", label: song.instrument.label))
            if let key = song.key {
                items.append(detailLabel(icon: "􀟕", label: key.displayName(options: .init())))
            }
            if let capo = song.capo {
                items.append(detailLabel(icon: "􀉢", label: capo))
            }
            if let time = song.time {
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

extension StringAttributes {
    static var songDetailIcon: StringAttributes {
        [
            .foregroundColor: SWIFTColor.gray,
            .font: SWIFTFont.systemFont(ofSize: 8, weight: .regular)
        ] + alignment(.center)
    }
    static var songDetailLabel: StringAttributes {
        [
            .foregroundColor: SWIFTColor.black,
            .font: SWIFTFont.systemFont(ofSize: 8, weight: .regular)
        ] + alignment(.center)
    }
}
