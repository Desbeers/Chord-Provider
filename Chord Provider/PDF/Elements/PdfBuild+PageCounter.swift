//
//  PdfBuild+PageCounter.swift
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

    /// A PDF pagecounter item
    open class TextPageCounter: PdfElement {
        public var pageNumber: Int
        public var format: String
        public var attributes: StringAttributes

        public var songs = Set<SongInfo>()

        let padding: CGFloat = 2

        public init(pageNumber: Int, format: String = "%i", attributes: StringAttributes = StringAttributes()) {
            self.pageNumber = pageNumber
            self.format = format
            self.attributes = attributes
        }

        open override func draw(rect: inout CGRect) {
            PdfBuild.log(pageNumber)
            let textRect = rect.insetBy(dx: padding, dy: padding)
            let text = NSAttributedString(
                string: String(format: format, pageNumber),
                attributes: attributes)
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

// MARK: Page counter string styling

public extension StringAttributes {

    static var pageCounter: StringAttributes {
        [
            .foregroundColor: SWIFTColor.gray,
            .font: SWIFTFont.systemFont(ofSize: 8, weight: .regular)
        ] + .alignment(.center)
    }
}
