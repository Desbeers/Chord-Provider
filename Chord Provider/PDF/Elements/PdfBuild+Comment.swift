//
//  PdfBuild+Comment.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension PdfBuild {

    /// A PDF comment item
    open class Comment: PdfElement {

        /// The comment
        let comment: String

        let leading = NSAttributedString(string: "􀌲", attributes: .sectionLabel)
        let label: NSAttributedString

        let commentColor = SWIFTColor(red: 0.95, green: 0.9, blue: 0.78, alpha: 1)

        public init(_ comment: String) {
            self.comment = comment
            self.label = NSAttributedString(string: comment, attributes: .sectionLabel)
        }

        open override func draw(rect: inout CGRect) {
            let label = PdfBuild.Label(
                leading: leading,
                label: label,
                color: commentColor,
                alignment: .left
            )
            label.draw(rect: &rect)
        }
    }
}
