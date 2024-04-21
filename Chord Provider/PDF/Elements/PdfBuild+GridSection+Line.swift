//
//  PdfBuild+GridSection+Line.swift
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

extension PdfBuild.GridSection {

    open class Line: PdfElement {

        let grid: [Song.Section.Line.Grid]

        let chords: [ChordDefinition]

        let padding: CGFloat = 2

        init(_ grid: [Song.Section.Line.Grid], chords: [ChordDefinition]) {
            self.grid = grid
            self.chords = chords
        }

        open override func draw(rect: inout CGRect) {
            PdfBuild.log(grid)

            var items: [NSAttributedString] = []

            for part in grid {
                items.append(
                    NSAttributedString(
                        string: "|",
                        attributes: [.font: SWIFTFont.systemFont(ofSize: 10, weight: .regular)]
                    )
                )
                for part in part.parts {
                    if let chord = part.chord, let first = chords.first(where: { $0.id == chord }) {
                        items.append(
                            NSAttributedString(
                                string: first.displayName(options: .init()),
                                attributes: [.font: SWIFTFont.systemFont(ofSize: 10, weight: .regular), .foregroundColor: SWIFTColor.gray]
                            )
                        )
                    }
                    if !part.text.isEmpty {
                        items.append(
                            NSAttributedString(
                                string: part.text,
                                attributes: [.font: SWIFTFont.systemFont(ofSize: 10, weight: .regular)]
                            )
                        )
                    }
                }
            }

            let line = items.joined(with: "  ")

            let textRect = rect.insetBy(dx: padding, dy: padding)

            let textBounds = line.bounds(withSize: textRect.size)

            let options: NSString.DrawingOptions = [
                /// Render the string in multiple lines
                .usesLineFragmentOrigin,
                .truncatesLastVisibleLine
            ]

            line.draw(with: textRect, options: options, context: nil)

            let height = textBounds.height + 2 * padding
            rect.origin.y += height
            rect.size.height -= height
        }
    }
}
