//
//  PDFBuild+Builder.swift
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

    public class Builder {

        init(info: PDFBuild.DocumentInfo) {
            self.document = info
            self.pdfInfo = info.dictonary
            self.pageMargin = SWIFTEdgeInsets(
                top: info.pagePadding,
                left: info.pagePadding,
                bottom: info.pagePadding,
                right: info.pagePadding
            )
        }

        let document: PDFBuild.DocumentInfo

        let pdfInfo: [CFString: String]

        let pageMargin: SWIFTEdgeInsets

        private var pageHeader: PDFBuild.PageHeader?
        public var pageCounter: PDFBuild.PageCounter?

        public var items = [PDFElement]()

        private var pageStarted = false

        public func generatePdf(
            progress: @escaping (Float) -> Void = { _ in }
        ) -> NSMutableData {
            let pdfData = beginPdfContextToData(pageRect: document.pageRect)
            appendPdf(progress: progress)
            endPdfContext()
            return pdfData
        }

        public func appendPdf(progress: @escaping (Float) -> Void = { _ in }) {

            var currentRect = document.pageRect

            /// If page header not set then create first page
            if let item = items.first as? PDFBuild.PageHeader {
                pageHeader = item
            } else {
                currentRect = beginPage()
            }

            for (index, item) in items.enumerated() {
                progress(Float(index) / Float(items.count))

                if let item = item as? PDFBuild.PageHeader {
                    pageHeader = item
                    currentRect = beginPage()
                } else {
                    if item.shoudPageBreak(rect: currentRect) {
                        endPage()
                        currentRect = beginPage()
                    }
                    item.draw(rect: &currentRect, calculationOnly: calculationOnly)
                }
            }
        }

        private func beginPage() -> CGRect {
            pageStarted = true

            beginPdfPage()

            if let pageCounter = pageCounter {
                pageCounter.pageNumber += 1
            }

            var page = document.pageRect.inset(by: pageMargin)

            pageHeader?.draw(rect: &page, calculationOnly: calculationOnly)

            return page
        }

        private func endPage() {
            pageStarted = false
            PDFBuild.pdfContext?.endPDFPage()
        }
    }
}

extension PDFBuild.Builder {

    func beginPdfContextToData(pageRect: CGRect) -> NSMutableData {
        let pdfData = NSMutableData()
#if os(macOS)
        guard
            let pdfConsumer = CGDataConsumer(data: pdfData as CFMutableData),
            let pdfContext = CGContext(consumer: pdfConsumer, mediaBox: nil, pdfInfo as CFDictionary)
        else {
            return pdfData
        }
        PDFBuild.pdfContext = pdfContext
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
        PDFBuild.pdfContext?.closePDF()
        NSGraphicsContext.restoreGraphicsState()
#else
        UIGraphicsEndPDFContext()
#endif
    }

    func beginPdfPage() {
#if os(macOS)
        let pageInfo = [
            kCGPDFContextMediaBox: document.pageRect
        ] as CFDictionary

        PDFBuild.pdfContext?.beginPDFPage(pageInfo)
        /// Scale and translate to flip vertically
        PDFBuild.pdfContext?.translateBy(x: 0, y: document.pageRect.height)
        PDFBuild.pdfContext?.scaleBy(x: 1.0, y: -1.0)
#else
        UIGraphicsBeginPDFPage()
#endif
    }
}
