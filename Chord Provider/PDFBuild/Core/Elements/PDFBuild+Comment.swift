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

        /// The leading text of the comment
        let leadingText: NSAttributedString
        /// The comment text
        let commentText: NSAttributedString
        /// The PDF settings
        let settings: AppSettings.PDF

        /// Init the **comment** element
        /// - Parameters:
        ///   - commentText: The text of the comment
        ///   - backgroundColor: The background color
        ///   - icon: The icon
        ///   - settings: The PDF settings
        init(_ commentText: String, icon: String = "􀌲", settings: AppSettings.PDF) {
            self.leadingText = NSAttributedString(string: icon, attributes: .attributes(.comment, settings: settings))
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
                leadingText: leadingText,
                labelText: commentText,
                backgroundColor: NSColor(settings.fonts.comment.background),
                alignment: .left
            )
            label.draw(rect: &rect, calculationOnly: calculationOnly, pageRect: pageRect)
        }
    }
}
