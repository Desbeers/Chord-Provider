//
//  PDFBuild+GridSection+Line.swift
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

extension PDFBuild.GridSection {

    open class Line: PDFElement {

        let grid: [Song.Section.Line.Grid]

        let chords: [ChordDefinition]

        init(_ grid: [Song.Section.Line.Grid], chords: [ChordDefinition]) {
            self.grid = grid
            self.chords = chords
        }

        open override func draw(rect: inout CGRect, calculationOnly: Bool) {

            var items: [NSAttributedString] = []

            for part in grid {
                items.append(
                    NSAttributedString(
                        string: "|",
                        attributes: .gridText
                    )
                )
                for part in part.parts {
                    if let chord = part.chord, let first = chords.first(where: { $0.id == chord }) {
                        items.append(
                            NSAttributedString(
                                string: first.displayName(options: .init()),
                                attributes: .gridChord
                            )
                        )
                    }
                    if !part.text.isEmpty {
                        items.append(
                            NSAttributedString(
                                string: part.text,
                                attributes: .gridText
                            )
                        )
                    }
                }
            }

            let line = items.joined(with: "  ")

            let textRect = rect.insetBy(dx: PDFElement.textPadding, dy: PDFElement.textPadding)

            let textBounds = line.bounds(withSize: textRect.size)

            if !calculationOnly {
                line.draw(with: textRect, options: textDrawingOptions, context: nil)
            }

            let height = textBounds.height + 2 * PDFElement.textPadding
            rect.origin.y += height
            rect.size.height -= height
        }
    }
}

extension StringAttributes {

    /// String attributes for a grid line
    static var gridText: StringAttributes {
        [
            .foregroundColor: SWIFTColor.black,
            .font: SWIFTFont.monospacedSystemFont(ofSize: 10, weight: .regular)
        ]
    }
    static var gridChord: StringAttributes {
        [
            .foregroundColor: SWIFTColor.gray,
            .font: SWIFTFont.monospacedSystemFont(ofSize: 10, weight: .regular)
        ]
    }
}
