//
//  PdfBuild+Builder.swift
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

    public class Builder {

        init(info: PdfBuild.DocumentInfo) {
            self.pdfInfo = info.dictonary
        }

        var pdfInfo: [CFString: String]

        private(set) var fullPageRect = CGRect.zero
        public var pageMargin = SWIFTEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)

        private var pageHeader: PdfBuild.PageHeader?
        public var pageCounter: PdfBuild.TextPageCounter?

        public var items = [PdfElement]()

        private var pageStarted = false

        public func generatePdf(
            pageRect: CGRect = PdfBuild.a4portraitPage,
            progress: @escaping (Float) -> Void = { _ in }
        ) -> NSMutableData {
            fullPageRect = pageRect

            let pdfData = beginPdfContextToData(pageRect: pageRect)
            appendPdf(progress: progress)
            endPdfContext()
            return pdfData
        }

        public func appendPdf(progress: @escaping (Float) -> Void = { _ in }) {

            var currentRect = fullPageRect

            /// If page header not set then create first page
            if let item = items.first as? PdfBuild.PageHeader {
                pageHeader = item
            } else {
                currentRect = beginPage()
            }

            for (index, item) in items.enumerated() {
                progress(Float(index) / Float(items.count))

                if let item = item as? PdfBuild.PageHeader {
                    pageHeader = item
                    currentRect = beginPage()
                } else {
                    if item.shoudPageBreak(rect: currentRect) {
                        endPage()
                        currentRect = beginPage()
                    }
                    item.draw(rect: &currentRect)
                }
            }
        }

        private func beginPage() -> CGRect {
            pageStarted = true

            beginPdfPage()

            if let pageCounter = pageCounter {
                pageCounter.pageNumber += 1
            }

            var page = fullPageRect.inset(by: pageMargin)

            pageHeader?.draw(rect: &page)

            return page
        }

        private func endPage() {
            pageStarted = false
            PdfBuild.pdfContext?.endPDFPage()
        }
    }
}

extension PdfBuild.Builder {

    func beginPdfContextToData(pageRect: CGRect) -> NSMutableData {
        let pdfData = NSMutableData()
#if os(macOS)
        guard
            let pdfConsumer = CGDataConsumer(data: pdfData as CFMutableData),
            let pdfContext = CGContext(consumer: pdfConsumer, mediaBox: nil, pdfInfo as CFDictionary)
        else {
            return pdfData
        }
        PdfBuild.pdfContext = pdfContext
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(cgContext: pdfContext, flipped: true)
#else
        UIGraphicsBeginPDFContextToData(pdfData, pageRect, pdfInfo)
#endif
        return pdfData
    }

    func endPdfContext() {
#if os(macOS)
        endPage()
        PdfBuild.pdfContext?.closePDF()
        NSGraphicsContext.restoreGraphicsState()
#else
        UIGraphicsEndPDFContext()
#endif
    }

    func beginPdfPage() {
        PdfBuild.log()
#if os(macOS)
        let pageInfo = [
            kCGPDFContextMediaBox: fullPageRect
        ] as CFDictionary

        PdfBuild.pdfContext?.beginPDFPage(pageInfo)
        /// Scale and translate to flip vertically
        PdfBuild.pdfContext?.translateBy(x: 0, y: fullPageRect.height)
        PdfBuild.pdfContext?.scaleBy(x: 1.0, y: -1.0)
#else
        UIGraphicsBeginPDFPage()
#endif
    }
}
