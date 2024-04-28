//
//  PDFBuild+Chords.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation
import SwiftlyChordUtilities

extension PDFBuild {

    /// A PDF **chords** element
    ///
    /// Display all the chord diagrams of the song
    class Chords: PDFElement {

        /// All the chords from the song
        let chords: [ChordDefinition]
        /// The chord display options
        let options: ChordDefinition.DisplayOptions

        /// Init the **chords** element
        /// - Parameters:
        ///   - chords: All the chords from the song
        ///   - options: The chord display options
        init(chords: [ChordDefinition], options: ChordDefinition.DisplayOptions) {
            self.chords = chords
            self.options = options
        }

        /// Draw the **chords** element as a `Section` element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        func draw(rect: inout CGRect, calculationOnly: Bool) {
            var items: [PDFElement] = []
            for chord in chords where chord.status != .unknown {
                items.append(Diagram(chord: chord, options: options))
            }
            let chords = PDFBuild.Section(columns: [SectionColumnWidth].init(repeating: .flexible, count: 7), items: items)
            chords.draw(rect: &rect, calculationOnly: calculationOnly)
        }
    }
}
