//
//  PDFBuild+TextblockSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import AppKit

extension PDFBuild {

    // MARK: A PDF **textblock section** element

    /// A PDF **textblock section** element
    class TextblockSection: PDFElement {

        /// The section with textblock
        let section: Song.Section
        /// All the chords of the song
        let chords: [ChordDefinition]

        /// Init the **textblock section** element
        /// - Parameters:
        ///   - section: The section with textblock
        ///   - chords: All the chords of the song
        init(_ section: Song.Section, chords: [ChordDefinition]) {
            self.section = section
            self.chords = chords
        }

        /// Draw the **textblock section** element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            for line in section.lines {
                if let parts = line.parts {
                    let text = NSMutableAttributedString()
                    for part in parts {
                        if let chord = chords.first(where: { $0.id == part.chord }) {
                            text.append(
                                NSAttributedString(
                                    /// Add a space behind the chord-name so two chords will never 'stick' together
                                    string: "\(chord.display)",
                                    attributes: .partChord(chord.status)
                                )
                            )
                        }
                        text.append(NSAttributedString(
                            string: "\(part.text)",
                            attributes: .textblockLine)
                        )
                    }
                    let textBounds = text.boundingRect(with: rect.size, options: .usesLineFragmentOrigin)
                    if !calculationOnly {
                        text.draw(with: rect, options: textDrawingOptions, context: nil)
                    }
                    let height = textBounds.height + 2 * textPadding
                    rect.origin.y += height
                    rect.size.height -= height
                }
            }
        }
    }
}

extension PDFStringAttribute {

    // MARK: Textblock string styling

    /// String attributes for a textblock  line
    static var textblockLine: PDFStringAttribute {
        [
            .foregroundColor: NSColor.gray
        ]
    }
}
