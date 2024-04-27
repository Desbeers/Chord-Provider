//
//  PDFBuild+TabSection+Line.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension PDFBuild.TabSection {

    open class Line: PDFElement {

        let tab: String

        public init(_ tab: String) {
            self.tab = tab
        }

        open override func draw(rect: inout CGRect, calculationOnly: Bool) {

            let textRect = rect.insetBy(dx: PDFElement.textPadding, dy: PDFElement.textPadding)

            let characters = tab.count

            let fontSize = min(textRect.width / CGFloat(characters), 10)

            let text = NSAttributedString(
                string: tab,
                attributes: .tabLine(fontSize: fontSize)
            )

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

// MARK: Tab line string styling

public extension StringAttributes {

    static func tabLine(fontSize: CGFloat) -> StringAttributes {
        [
            .foregroundColor: SWIFTColor.black,
            .font: SWIFTFont.monospacedSystemFont(ofSize: fontSize, weight: .regular)
        ]
    }
}
