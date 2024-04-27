//
//  PDFElement.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation

open class PDFElement {

    weak var builder: PDFBuild.Builder?

    /// The default padding for text
    /// - Note: Static because it is used in inits
    static let textPadding: CGFloat = 2

    /// The default text drawing options
    let textDrawingOptions: NSString.DrawingOptions = [
        /// Render the string in multiple lines
        .usesLineFragmentOrigin,
        .truncatesLastVisibleLine
    ]

    open func shoudPageBreak(rect: CGRect) -> Bool {
        PDFBuild.calculationOnly = true
        var tempRect = rect
        draw(rect: &tempRect, calculationOnly: true)
        PDFBuild.calculationOnly = false
        let breakPage = tempRect.origin.y > rect.maxY || rect.height < 10
        return breakPage
    }

    open func draw(rect: inout CGRect, calculationOnly: Bool) {
    }

    open func calculateDraw(rect: CGRect, elements: [PDFElement]) -> CGRect {
        PDFBuild.calculationOnly = true
        var tempRect = rect
        for item in elements {
            item.draw(rect: &tempRect, calculationOnly: true)
        }
        PDFBuild.calculationOnly = false
        return tempRect
    }

    open func stringToMarkdown(_ text: String) -> NSAttributedString {
        do {
            return try NSAttributedString(markdown: text)
        } catch {
            return NSAttributedString(string: text)
        }
    }
}
