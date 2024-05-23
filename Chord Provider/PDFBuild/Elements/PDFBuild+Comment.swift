//
//  PDFBuild+Comment.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension PDFBuild {

    /// A PDF **comment** element
    class Comment: PDFElement {

        /// The leading text of the comment
        let leadingText = NSAttributedString(string: "􀌲", attributes: .sectionLabel)
        /// The comment text
        let commentText: NSAttributedString

        /// Init the **comment** element
        /// - Parameter commentText: The text of the comment
        init(_ commentText: String) {
            self.commentText = NSAttributedString(string: commentText, attributes: .sectionLabel)
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
                backgroundColor: .comment,
                alignment: .left
            )
            label.draw(rect: &rect, calculationOnly: calculationOnly, pageRect: pageRect)
        }
    }
}
