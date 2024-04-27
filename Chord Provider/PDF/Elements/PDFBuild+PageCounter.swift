//
//  PDFBuild+PageCounter.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension PDFBuild {

    /// A PDF pagecounter item
    open class PageCounter: PDFElement {
        public let startPage: Int
        public var pageNumber: Int
        public var format: String
        public var attributes: StringAttributes

        public var songs: [SongInfo] = []

        public init(startPage: Int, format: String = "%i", attributes: StringAttributes = StringAttributes()) {
            self.startPage = startPage
            self.pageNumber = startPage
            self.format = format
            self.attributes = attributes
        }

        open override func draw(rect: inout CGRect, calculationOnly: Bool) {
            let textRect = rect.insetBy(dx: PDFElement.textPadding, dy: PDFElement.textPadding)
            let text = NSAttributedString(
                string: String(format: format, pageNumber),
                attributes: attributes)
            let textBounds = text.bounds(withSize: textRect.size)
            if !calculationOnly {
                text.draw(with: textRect, options: textDrawingOptions, context: nil)
            }
            let height = textBounds.height + 2 * PDFElement.textPadding
            rect.origin.y += height
            rect.size.height -= height
        }
    }
}

// MARK: Page counter string styling

public extension StringAttributes {

    static var pageCounter: StringAttributes {
        [
            .foregroundColor: SWIFTColor.gray,
            .font: SWIFTFont.systemFont(ofSize: 8, weight: .regular)
        ] + .alignment(.center)
    }
}
