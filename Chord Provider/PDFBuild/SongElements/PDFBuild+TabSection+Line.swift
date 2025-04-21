//
//  PDFBuild+TabSection+Line.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension PDFBuild.TabSection {

    // MARK: A PDF **line** element for a `TabSection`

    /// A PDF **line** element for a `TabSection`
    ///
    /// Display line of a tab section of the song
    class Line: PDFElement {

        /// The line with the tab
        let tab: String
        /// The application settings
        let settings: AppSettings

        /// Init the **tab** item
        /// - Parameters:
        ///   - tab: The line with the tab
        ///   - settings: The application settings
        init(_ tab: String, settings: AppSettings) {
            self.tab = tab
            self.settings = settings
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
            let fontSize = min(textRect.width / (Double(characters) * 0.7), settings.style.fonts.text.size)
            let text = NSAttributedString(
                string: tab,
                attributes: .tabLine(fontSize: fontSize, settings: settings)
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
    static func tabLine(fontSize: CGFloat, settings: AppSettings) -> PDFStringAttribute {
        [
            .foregroundColor: settings.style.theme.foreground.nsColor,
            .font: NSFont.monospacedSystemFont(ofSize: fontSize, weight: .regular)
        ]
    }
}
