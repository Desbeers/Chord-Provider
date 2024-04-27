//
//  PDFBuild+Text.swift
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

    /// A PDF text item
    open class Text: PDFElement {

        let text: NSAttributedString
        let size: CGSize

        public init(_ text: String, attributes: StringAttributes = StringAttributes()) {
            self.text = NSAttributedString(
                string: text,
                attributes: attributes
            )
            self.size = self.text.size()
        }

        public init(_ text: NSAttributedString) {

            self.text = text
            var size = self.text.size()
            /// Add a bit extra width if the text ends with a `space`
            if text.string.last == " " {
                size.width += 2 * PDFElement.textPadding
            }
            self.size = size
        }

        open override func draw(rect: inout CGRect, calculationOnly: Bool) {
            let textRect = rect.insetBy(dx: PDFElement.textPadding, dy: PDFElement.textPadding)

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
