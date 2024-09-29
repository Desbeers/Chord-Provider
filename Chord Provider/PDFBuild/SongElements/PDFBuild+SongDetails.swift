//
//  PDFBuild+SongDetails.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import AppKit

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
            let items = NSMutableAttributedString()
            items.append(detailLabel(icon: "􀑭", label: song.settings.song.instrument.label))
            if let key = song.metaData.key {
                items.append(detailLabel(icon: "􀟕", label: key.displayName))
            }
            if let capo = song.metaData.capo {
                items.append(detailLabel(icon: "􀉢", label: capo))
            }
            if let time = song.metaData.time {
                items.append(detailLabel(icon: "􀐱", label: time))
            }
            /// Draw the details
            let textBounds = items.boundingRect(with: rect.size, options: .usesLineFragmentOrigin)
            if !calculationOnly {
                items.draw(with: rect, options: textDrawingOptions, context: nil)
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
            let result = NSMutableAttributedString()
            result.append(NSAttributedString(string: icon, attributes: .songDetailIcon))
            result.append(NSAttributedString(string: " "))
            result.append(NSAttributedString(string: label, attributes: .songDetailLabel))
            result.append(NSAttributedString(string: " "))
            return result
        }
    }
}

extension PDFStringAttribute {

    // MARK: Song Detail string styling

    /// String attributes for a song detail icon
    static var songDetailIcon: PDFStringAttribute {
        [
            .foregroundColor: NSColor.gray,
            .font: NSFont.systemFont(ofSize: 8, weight: .regular)
        ] + alignment(.center)
    }

    /// String attributes for a song detail label
    static var songDetailLabel: PDFStringAttribute {
        [
            .foregroundColor: NSColor.black,
            .font: NSFont.systemFont(ofSize: 8, weight: .regular)
        ] + alignment(.center)
    }
}
