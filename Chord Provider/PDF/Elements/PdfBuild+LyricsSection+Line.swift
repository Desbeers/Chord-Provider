//
//  PdfBuild+LyricsSection+Line.swift
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

extension PdfBuild.LyricsSection {

    /// A collection of parts that makes a line in a song
    open class Line: PdfElement {

        let parts: [Part]
        let height: CGFloat

        /// A collection of parts that makes a line in a song
        /// - Parameters:
        ///   - parts: The parts of the line
        ///   - chords: All the chords in the song
        init(parts: [Song.Section.Line.Part], chords: [ChordDefinition]) {
            var items: [Part] = []
            for part in parts {
                items.append(Part(part: part, chords: chords))
            }
            self.parts = items
            self.height = items.first?.size.height ?? 0
        }

        open override func draw(rect: inout CGRect) {
            var partOffset: CGFloat = 0
            for part in parts {
                var cellRect = CGRect(
                    x: rect.minX + partOffset,
                    y: rect.minY,
                    width: part.size.width,
                    height: part.size.height
                )
                partOffset += part.size.width
                part.draw(rect: &cellRect)
            }
            rect.origin.y += height
            rect.size.height -= height
        }
    }
}
