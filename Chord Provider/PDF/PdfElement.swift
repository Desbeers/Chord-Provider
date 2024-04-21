//
//  PdfElement.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation

open class PdfElement {

    weak var builder: PdfBuild.Builder?

    open func shoudPageBreak(rect: CGRect) -> Bool {
        PdfBuild.isEstimating = true
        var tempRect = rect
        _ = PdfBuild.drawImage(size: CGSize(width: rect.maxX, height: rect.maxY)) {
            draw(rect: &tempRect)
        }
        PdfBuild.isEstimating = false
        let breakPage = tempRect.origin.y > rect.maxY || rect.height < 10
        PdfBuild.log(breakPage)
        return breakPage
    }

    open func draw(rect: inout CGRect) {
    }

    open func estimateDraw(rect: CGRect, elements: [PdfElement]) -> CGRect {
        PdfBuild.isEstimating = true
        var tempRect = rect
        _ = PdfBuild.drawImage(size: rect.size) {
            for item in elements {
                item.draw(rect: &tempRect)
            }
        }
        PdfBuild.isEstimating = false
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
