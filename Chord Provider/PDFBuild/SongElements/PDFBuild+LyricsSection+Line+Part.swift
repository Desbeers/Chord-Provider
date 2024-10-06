//
//  PDFBuild+LyricsSection+Line+Part.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import AppKit

extension PDFBuild.LyricsSection.Line {

    // MARK: A PDF **part** element for a `Line` in a `LyricsSection`

    /// A PDF **part** element for a `Line` in a `LyricsSection`
    class Part: PDFElement {

        /// The text of the part
        /// - Note: A merge of the optional chord and optional lyrics part
        let text = NSMutableAttributedString()
        /// The size of the part
        /// - Note: Used by the `Line` element to define the rectangle
        let size: CGSize

        /// Init the **part** element
        /// - Parameters:
        ///   - part: The part of the lyrics line
        ///   - chords: All the chords of the song
        init(part: Song.Section.Line.Part, chords: [ChordDefinition]) {
            if chords.isEmpty {
                self.text.append(
                    NSAttributedString(
                        string: "\(part.text)",
                        attributes: .partLyric
                    )
                )
            } else {
                var chordString: String = " "
                var chordStatus: Chord.Status = .unknownChord
                if let chord = chords.first(where: { $0.id == part.chord }) {
                    chordString = chord.display
                    chordStatus = chord.status
                }
                self.text.append(
                    NSAttributedString(
                        /// Add a space behind the chord-name so two chords will never 'stick' together
                        string: "\(chordString) \n",
                        attributes: .partChord(chordStatus)
                    )
                )
                self.text.append(NSAttributedString(
                    string: "\(part.text)",
                    attributes: .partLyric)
                )
            }
            self.size = text.size()
        }

        /// Draw the **part** element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
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

extension PDFStringAttribute {

    // MARK: Part string styling

    /// Style attributes for the chord of the part
    static func partChord(_ status: Chord.Status) -> PDFStringAttribute {
        [
            .foregroundColor: status == .unknownChord ? NSColor.red : NSColor.gray,
            .font: NSFont.systemFont(ofSize: 10, weight: .regular)
        ]
    }

    /// Style attributes for the lyric of the part
    static var partLyric: PDFStringAttribute {
        [
            .foregroundColor: NSColor.black,
            .font: NSFont.systemFont(ofSize: 10, weight: .regular)
        ]
    }
}
