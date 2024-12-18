//
//  PDFBuild+Comment.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import AppKit

extension PDFBuild {

    // MARK: A PDF **comment** element

    /// A PDF **comment** element
    class Comment: PDFElement {

        /// The leading text of the comment
        let leadingText: NSAttributedString
        /// The comment text
        let commentText: NSAttributedString
        /// Background color
        let backgroundColor: NSColor

        /// Init the **comment** element
        /// - Parameter commentText: The text of the comment
        init(_ commentText: String, icon: String = "􀌲", backgroundColor: NSColor = .pdfComment) {
            self.leadingText = NSAttributedString(string: icon, attributes: .commentLabel)
            self.commentText = NSAttributedString(string: commentText, attributes: .commentLabel)
            self.backgroundColor = backgroundColor
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
                backgroundColor: backgroundColor,
                alignment: .left
            )
            label.draw(rect: &rect, calculationOnly: calculationOnly, pageRect: pageRect)
        }
    }
}

extension PDFStringAttribute {

    // MARK: Command string styling

    /// Style attributes for a comment
    static var commentLabel: PDFStringAttribute {
        [
            .foregroundColor: NSColor.black,
            .font: NSFont.systemFont(ofSize: 8, weight: .regular)
        ]
    }
}
