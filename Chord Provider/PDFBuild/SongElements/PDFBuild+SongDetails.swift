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
    ///
    /// Display metadata details of the song
    class SongDetails: PDFElement {

        /// The ``Song``
        let song: Song
        /// The application settings
        let settings: AppSettings

        /// Init the **song details** element
        /// - Parameters:
        ///   - song: The ``Song``
        ///   - settings: The application settings
        init(song: Song, settings: AppSettings) {
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
            items.append(detailLabel(sfSymbol: .instrument, label: song.settings.display.instrument.label))
            if let key = song.metadata.key {
                items.append(detailLabel(sfSymbol: .key, label: key.display))
            }
            if let capo = song.metadata.capo {
                items.append(detailLabel(sfSymbol: .capo, label: capo))
            }
            if let time = song.metadata.time {
                items.append(detailLabel(sfSymbol: .time, label: time))
            }
            if let tempo = song.metadata.tempo {
                items.append(detailLabel(sfSymbol: .tempo, label: "\(tempo) bpm"))
            }
            /// Draw the details
            let textBounds = items.boundingRect(with: rect.size)
            if !calculationOnly {
                items.draw(with: rect, options: textDrawingOptions, context: nil)
            }
            let height = textBounds.height + 2 * textPadding
            rect.origin.y += height
            rect.size.height -= height
        }

        /// Make a detail label
        /// - Parameters:
        ///   - sfSymbol: The SF symbol as `String`
        ///   - label: The label as `String`
        /// - Returns: An `NSAttributedString` with icon, label and attributes
        private func detailLabel(sfSymbol: SFSymbol, label: String) -> NSAttributedString {
            let imageAttachment = NSTextAttachment().sfSymbol(
                sfSymbol: sfSymbol.rawValue,
                fontSize: settings.style.fonts.text.size * 0.8,
                colors: [settings.style.theme.foregroundMedium.nsColor]
            )
            let result = NSMutableAttributedString()
            result.append(NSAttributedString(attachment: imageAttachment, attributes: .alignment(.center)))
            result.append(NSAttributedString(string: " \(label)   ", attributes: .smallTextFont(settings: settings)))
            return result
        }
    }
}
