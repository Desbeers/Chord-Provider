//
//  PDFBuild+Chords.swift
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

    /// A PDF chords item
    open class Chords: PDFElement {

        let chords: [ChordDefinition]

        let options: ChordDefinition.DisplayOptions

        var chordNameHeight: CGFloat = 0

        init(chords: [ChordDefinition], options: ChordDefinition.DisplayOptions) {
            self.chords = chords
            self.options = options
        }

        open override func draw(rect: inout CGRect, calculationOnly: Bool) {

            var items: [PDFElement] = []
            for chord in chords where chord.status != .unknown {
                items.append(Diagram(chord: chord, options: options))
            }
            let chords = PDFBuild.Section(columns: [SectionColumnWidth].init(repeating: .flexible, count: 7), items: items)
            chords.draw(rect: &rect, calculationOnly: calculationOnly)
        }
    }
}
