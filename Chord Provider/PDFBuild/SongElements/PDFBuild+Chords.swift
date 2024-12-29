//
//  PDFBuild+Chords.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension PDFBuild {

    // MARK: A PDF **chords** element

    /// A PDF **chords** element
    ///
    /// Display all the chord diagrams of the song
    class Chords: PDFElement {

        /// All the chords from the song
        let chords: [ChordDefinition]
        /// The chord display options
        let options: AppSettings.DiagramDisplayOptions

        /// Init the **chords** element
        /// - Parameters:
        ///   - chords: All the chords from the song
        ///   - options: The chord display options
        init(chords: [ChordDefinition], options: AppSettings.DiagramDisplayOptions) {
            self.chords = chords
                .sorted(using: KeyPathComparator(\.root))
                .sorted(using: KeyPathComparator(\.quality))
            self.options = options
        }

        /// Draw the **chords** element as a `Section` element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            let chords = chords.filter { $0.status != .unknownChord } .sorted(using: KeyPathComparator(\.name))
            var items: [PDFElement] = []
            for chord in chords {
                items.append(Diagram(chord: chord, options: options))
            }
            /// Spread the chords evenly over multiple lines
            let chordsCount = chords.count
            let lines = Int((chordsCount - 1) / 7) + 1
            let lineItems = Int((chordsCount - 1) / lines) + 1
            let diagramWidth = rect.width / 7
            let diagrams = PDFBuild.Section(
                columns: .init(repeating: .fixed(width: diagramWidth), count: lineItems),
                items: items
            )
            /// Keep the original X value
            let tempOriginX = rect.origin.x
            /// Move the diagrams if we have less than 7 in a row
            let extraX = (Double(7 - lineItems) / 2) * diagramWidth
            rect.origin.x += extraX
            diagrams.draw(rect: &rect, calculationOnly: calculationOnly, pageRect: pageRect)
            /// Restore the original X value
            rect.origin.x = tempOriginX
        }
    }
}
