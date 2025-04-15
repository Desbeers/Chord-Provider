//
//  PDFBuild+Comment.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension PDFBuild {

    // MARK: A PDF **comment** element

    /// A PDF **comment** element
    class Comment: PDFElement {

        /// The comment text
        let commentText: NSAttributedString
        /// The application settings
        let settings: AppSettings

        /// Init the **comment** element
        /// - Parameters:
        ///   - commentText: The text of the comment
        ///   - settings: The application settings
        init(_ commentText: String, settings: AppSettings) {
            self.commentText = NSAttributedString(string: commentText, attributes: .attributes(.comment, settings: settings))
            self.settings = settings
        }

        /// Draw the **comment** element as a `Label` element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            let label = PDFBuild.Label(
                labelText: commentText,
                sfSymbol: "text.bubble",
                drawBackground: true,
                alignment: .left,
                fontOptions: settings.style.fonts.comment
            )
            label.draw(rect: &rect, calculationOnly: calculationOnly, pageRect: pageRect)
        }
    }
}
