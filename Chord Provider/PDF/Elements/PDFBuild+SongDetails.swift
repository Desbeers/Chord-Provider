//
//  PDFBuild+SongDetails.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif
import SwiftlyChordUtilities

extension PDFBuild {

    /// A PDF song details item
    open class SongDetails: PDFElement {

        let song: Song

        init(song: Song) {
            self.song = song
        }

        open override func draw(rect: inout CGRect, calculationOnly: Bool) {

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

            let textBounds = text.bounds(withSize: rect.size)
            if !calculationOnly {
                text.draw(with: rect, options: textDrawingOptions, context: nil)
            }
            let height = textBounds.height + 2 * PDFElement.textPadding
            rect.origin.y += height
            rect.size.height -= height
        }

        func detailLabel(icon: String, label: String) -> NSAttributedString {
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
