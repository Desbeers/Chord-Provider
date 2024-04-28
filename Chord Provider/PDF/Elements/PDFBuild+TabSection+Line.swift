//
//  PDFBuild+TabSection+Line.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation

extension PDFBuild.TabSection {

    /// A PDF **line** element for a `TabSection`
    class Line: PDFElement {

        /// The line with the tab
        let tab: String

        /// Init the **tab** item
        /// - Parameter tab: The line with the tab
        init(_ tab: String) {
            self.tab = tab
        }

        /// Draw the **line** element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        func draw(rect: inout CGRect, calculationOnly: Bool) {
            let textRect = rect.insetBy(dx: textPadding, dy: textPadding)
            let characters = tab.count
            /// Calculate the font size so the line will not wrap
            let fontSize = min(textRect.width / CGFloat(characters), 10)
            let text = NSAttributedString(
                string: tab,
                attributes: .tabLine(fontSize: fontSize)
            )
            let textBounds = text.bounds(withSize: textRect.size)
            if !calculationOnly {
                text.draw(with: textRect, options: textDrawingOptions, context: nil)
            }
            let height = textBounds.height + 2 * textPadding
            rect.origin.y += height
            rect.size.height -= height
        }
    }
}

// MARK: Tab line string styling

public extension StringAttributes {

    /// Style atributes for the line of a tab
    static func tabLine(fontSize: CGFloat) -> StringAttributes {
        [
            .foregroundColor: SWIFTColor.black,
            .font: SWIFTFont.monospacedSystemFont(ofSize: fontSize, weight: .regular)
        ]
    }
}
