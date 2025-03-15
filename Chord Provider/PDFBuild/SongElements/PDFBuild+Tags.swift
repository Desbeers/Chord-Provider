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

        let settings: AppSettings.PDF

        init(song: Song, settings: AppSettings.PDF) {
            self.tags = song.metadata.tags
            self.settings = settings
        }

        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            var tagRect = pageRect
            tagRect.size.width -= pagePadding
            tagRect.origin.y += pagePadding
            for tag in tags {
                let text = NSAttributedString(string: tag, attributes: .tagLine + .foregroundColor(settings: settings))
                let render = PDFBuild.Label(
                    labelText: text,
                    backgroundColor: NSColor.red.withAlphaComponent(0.3),
                    alignment: .right,
                    settings: settings
                )
                    .padding(4)
                render.draw(rect: &tagRect, calculationOnly: calculationOnly, pageRect: pageRect)
            }
        }
    }
}

extension PDFStringAttribute {

    // MARK: Tag string styling

    /// String attributes for a tag  line
    static var tagLine: PDFStringAttribute {
        [
            .font: NSFont.systemFont(ofSize: 6, weight: .regular)
        ]
    }
}
