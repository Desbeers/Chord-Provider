//
//  PDFBuild+Tags.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import AppKit

extension PDFBuild {

    // MARK: A PDF **tags** element

    /// A PDF **tags** element
    ///
    /// Display all tags of the song
    class Tags: PDFElement {
        /// The array of tags
        let tags: [String]?
        /// The application settings
        let settings: AppSettings

        /// Init the **tags** element
        /// - Parameters:
        ///   - song: The whole `Song`
        ///   - settings: The ``AppSettings``
        init(song: Song, settings: AppSettings) {
            self.tags = song.metadata.tags
            self.settings = settings
        }

        /// Draw the **tags** element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            if !calculationOnly, let tags {
                var tagRect = pageRect
                    .insetBy(
                        dx: settings.pdf.pagePadding,
                        dy: settings.pdf.pagePadding
                    )
                for tag in tags {
                    let render = PDFBuild.Label(
                        labelText: tag,
                        sfSymbol: .tag,
                        drawBackground: true,
                        alignment: .right,
                        fontOptions: settings.style.fonts.tag
                    )
                        .padding(4)
                    render.draw(rect: &tagRect, calculationOnly: calculationOnly, pageRect: pageRect)
                }
            }
        }
    }
}
