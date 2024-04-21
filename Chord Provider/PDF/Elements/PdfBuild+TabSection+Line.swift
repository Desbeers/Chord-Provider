//
//  PdfBuild+TabSection+Line.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension PdfBuild.TabSection {

    open class Line: PdfElement {

        let tab: String
        let padding: CGFloat = 2

        public init(_ tab: String) {
            self.tab = tab
        }

        open override func draw(rect: inout CGRect) {
            PdfBuild.log(tab)

            let textRect = rect.insetBy(dx: padding, dy: padding)

            let characters = tab.count

            let fontSize = min(textRect.width / CGFloat(characters), 10)

            let text = NSAttributedString(
                string: tab,
                attributes: .tabLine(fontSize: fontSize)
            )

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

// MARK: Tab line string styling

public extension StringAttributes {

    static func tabLine(fontSize: CGFloat) -> StringAttributes {
        [
            .foregroundColor: SWIFTColor.black,
            .font: SWIFTFont.monospacedSystemFont(ofSize: fontSize, weight: .regular)
        ]
    }
}
