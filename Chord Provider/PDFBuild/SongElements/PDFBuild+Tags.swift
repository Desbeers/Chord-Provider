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
    class Tags: PDFElement {

        let tags: [String]

        let settings: AppSettings

        init(song: Song, settings: AppSettings) {
            self.tags = song.metadata.tags
            self.settings = settings
        }

        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            var tagRect = pageRect
            tagRect.size.width -= pagePadding
            tagRect.origin.y += pagePadding
            for tag in tags {
                let text = NSAttributedString(string: tag, attributes: .attributes(.tag, settings: settings))
                let render = PDFBuild.Label(
                    labelText: text,
                    backgroundColor: NSColor(settings.style.fonts.tag.background),
                    alignment: .right
                )
                    .padding(4)
                render.draw(rect: &tagRect, calculationOnly: calculationOnly, pageRect: pageRect)
            }
        }
    }
}
