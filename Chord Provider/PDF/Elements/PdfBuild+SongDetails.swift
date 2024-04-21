//
//  PdfBuild+SongDetails.swift
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

extension PdfBuild {

    /// A PDF song details item
    open class SongDetails: PdfElement {

        let song: Song
        let padding: CGFloat = 2

        init(song: Song) {
            self.song = song
        }


        open override func draw(rect: inout CGRect) {

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

            PdfBuild.log(text.string)
            let textBounds = text.bounds(withSize: rect.size)
            let options: NSString.DrawingOptions = [
                /// Render the string in multiple lines
                .usesLineFragmentOrigin,
                .truncatesLastVisibleLine
            ]
            text.draw(with: rect, options: options, context: nil)
            let height = textBounds.height + 2 * padding
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
