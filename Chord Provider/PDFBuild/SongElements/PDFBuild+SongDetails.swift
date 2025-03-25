//
//  PDFBuild+SongDetails.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension PDFBuild {

    // MARK: A PDF **song details** element

    /// A PDF **song details** element
    class SongDetails: PDFElement {

        /// The ``Song``
        let song: Song
        /// The PDF settings
        let settings: AppSettings.PDF

        /// Init the **song details** element
        /// - Parameters:
        ///   - song: The ``Song``
        ///   - settings: The PDF settings
        init(song: Song, settings: AppSettings.PDF) {
            self.song = song
            self.settings = settings
        }

        /// Draw the **song details** element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            /// Add the detail items
            let items = NSMutableAttributedString()
            items.append(detailLabel(icon: .instrument, label: song.settings.display.instrument.label))
            if let key = song.metadata.key {
                items.append(detailLabel(icon: .key, label: key.display))
            }
            if let capo = song.metadata.capo {
                items.append(detailLabel(icon: .capo, label: capo))
            }
            if let time = song.metadata.time {
                items.append(detailLabel(icon: .time, label: time))
            }
            if let tempo = song.metadata.tempo {
                items.append(detailLabel(icon: .tempo, label: "\(tempo) bpm"))
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
        private func detailLabel(icon: SVGIcon, label: String) -> NSAttributedString {
            guard let image = NSImage(data: icon.data(color: settings.theme.foregroundMedium)) else {
                return NSAttributedString()
            }
            image.isTemplate = true
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = image
            let imageSize = imageAttachment.image?.size ?? .init()
            imageAttachment.bounds = CGRect(
                x: CGFloat(0),
                y: (NSFont.systemFont(ofSize: settings.fonts.text.size * 0.8, weight: .regular).capHeight - imageSize.height) / 2,
                width: imageSize.width,
                height: imageSize.height
            )
            let result = NSMutableAttributedString()
            result.append(NSAttributedString(attachment: imageAttachment, attributes: .alignment(.center)))
            result.append(NSAttributedString(string: " \(label)   ", attributes: .smallTextFont(settings: settings) + .alignment(.center)))
            return result
        }
    }
}
