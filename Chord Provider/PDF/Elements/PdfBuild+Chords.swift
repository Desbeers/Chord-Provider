//
//  PdfBuild+Chords.swift
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
    
    /// A PDF chords item
    open class Chords: PdfElement {

        let chords: [ChordDefinition]

        let options: ChordDefinition.DisplayOptions

        var chordNameHeight: CGFloat = 0

        init(chords: [ChordDefinition], options: ChordDefinition.DisplayOptions) {
            self.chords = chords
            self.options = options
        }

        open override func draw(rect: inout CGRect) {

            var items: [PdfElement] = []
            for chord in chords where chord.status != .unknown {
                items.append(Diagram(chord: chord, options: options))
            }
            let chords = PdfBuild.Section(columns: [SectionColumnWidth].init(repeating: .flexible, count: 7), items: items)
            chords.draw(rect: &rect)
        }
    }
}
