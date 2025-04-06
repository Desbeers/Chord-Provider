//
//  PDFBuild+LyricsSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension PDFBuild {

    // MARK: A PDF **lyrics section** element

    /// A PDF **lyrics section** element
    class LyricsSection: PDFElement {

        /// The section with lyrics
        let section: Song.Section
        /// All the chords from the song
        let chords: [ChordDefinition]
        /// The application settings
        let settings: AppSettings

        /// Init the **lyrics section** element
        /// - Parameters:
        ///   - section: The section with lyrics
        ///   - chords: All the chords from the song
        ///   - settings: The PDF settings
        init(_ section: Song.Section, chords: [ChordDefinition], settings: AppSettings) {
            self.section = section
            self.chords = chords
            self.settings = settings
        }

        /// Draw the **lyrics section** element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            for line in section.lines {
                switch line.directive {
                case .environmentLine:
                    if let parts = line.parts {
                        let line = Line(parts: parts, chords: chords, settings: settings)
                        line.draw(rect: &rect, calculationOnly: calculationOnly, pageRect: pageRect)
                    }
                case .comment:
                    let comment = PDFBuild.Comment(line.plain, settings: settings).padding(6)
                    comment.draw(rect: &rect, calculationOnly: calculationOnly, pageRect: pageRect)
                default:
                    break
                }
            }
        }
    }
}
