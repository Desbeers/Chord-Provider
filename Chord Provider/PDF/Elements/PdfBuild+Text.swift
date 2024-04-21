//
//  PdfBuild+Text.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension PdfBuild {

    /// A PDF text item
    open class Text: PdfElement {

        let text: NSAttributedString
        let size: CGSize
        let padding: CGFloat = 2

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
                size.width += padding * 2
            }
            self.size = size
        }

        open override func draw(rect: inout CGRect) {
            PdfBuild.log(text.string)
            let textRect = rect.insetBy(dx: padding, dy: padding)

            let textBounds = text.bounds(withSize: textRect.size)

            let options: NSString.DrawingOptions = [
                /// Render the string in multiple lines
                .usesLineFragmentOrigin,
                .truncatesLastVisibleLine
            ]
            text.draw(with: textRect, options: options, context: nil)

            let height = textBounds.height + 2 * padding
            rect.origin.y += height
            rect.size.height -= height
        }
    }
}
