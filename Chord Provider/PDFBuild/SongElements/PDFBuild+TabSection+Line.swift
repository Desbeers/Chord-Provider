//
//  PDFBuild+TabSection+Line.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import AppKit

extension PDFBuild.TabSection {

    // MARK: A PDF **line** element for a `TabSection`

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
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            let textRect = rect.insetBy(dx: textPadding, dy: textPadding)
            let characters = tab.count
            /// Calculate the font size so the line will not wrap
            let fontSize = min(textRect.width / (Double(characters) * 0.7), 10)
            let text = NSAttributedString(
                string: tab,
                attributes: .tabLine(fontSize: fontSize)
            )
            let textBounds = text.boundingRect(with: rect.size, options: .usesLineFragmentOrigin)
            if !calculationOnly {
                text.draw(with: textRect, options: textDrawingOptions, context: nil)
            }
            let height = textBounds.height + 2 * textPadding
            rect.origin.y += height
            rect.size.height -= height
        }
    }
}

extension PDFStringAttribute {

    // MARK: Tab line string styling

    /// Style attributes for the line of a tab
    static func tabLine(fontSize: CGFloat) -> PDFStringAttribute {
        [
            .foregroundColor: NSColor.black,
            .font: NSFont.monospacedSystemFont(ofSize: fontSize, weight: .regular)
        ]
    }
}
