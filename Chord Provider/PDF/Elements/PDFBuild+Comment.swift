//
//  PDFBuild+Comment.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension PDFBuild {

    /// A PDF comment item
    open class Comment: PDFElement {

        /// The comment
        let comment: String

        let leading = NSAttributedString(string: "􀌲", attributes: .sectionLabel)
        let label: NSAttributedString

        public init(_ comment: String) {
            self.comment = comment
            self.label = NSAttributedString(string: comment, attributes: .sectionLabel)
        }

        open override func draw(rect: inout CGRect, calculationOnly: Bool) {
            let label = PDFBuild.Label(
                leading: leading,
                label: label,
                color: .comment,
                alignment: .left
            )
            label.draw(rect: &rect, calculationOnly: calculationOnly)
        }
    }
}
