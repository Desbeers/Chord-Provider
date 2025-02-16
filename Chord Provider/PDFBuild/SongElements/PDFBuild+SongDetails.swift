//
//  PDFBuild+SongDetails.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
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
            items.append(detailLabel(icon: "instrument", label: song.settings.display.instrument.label))
            if let key = song.metadata.key {
                items.append(detailLabel(icon: "key", label: key.display))
            }
            if let capo = song.metadata.capo {
                items.append(detailLabel(icon: "capo", label: capo))
            }
            if let time = song.metadata.time {
                items.append(detailLabel(icon: "time", label: time))
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
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = NSImage(named: icon)
            let result = NSMutableAttributedString()
            result.append(NSAttributedString(attachment: imageAttachment, attributes: .alignment(.center)))
            result.append(NSAttributedString(string: " "))
            result.append(NSAttributedString(string: label, attributes: .songDetailLabel))
            result.append(NSAttributedString(string: "  "))
            return result
        }
    }
}

extension PDFStringAttribute {

    // MARK: Song Detail string styling

    /// String attributes for a song detail label
    static var songDetailLabel: PDFStringAttribute {
        [
            .foregroundColor: NSColor.black,
            .font: NSFont.systemFont(ofSize: 8, weight: .regular)
        ] + alignment(.center)
    }
}
