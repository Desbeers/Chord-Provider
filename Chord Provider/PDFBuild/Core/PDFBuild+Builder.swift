//
//  PDFBuild+Builder.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import AppKit

extension PDFBuild {

    // MARK: The builder for `PDFElement` items

    /// Class to build a PDF with ``PDFElement`` items
    public class Builder {

        /// General document information
        let document: DocumentInfo
        /// Metadata info for the PDF file
        let auxiliaryInfo: [CFString: String]
        /// The optional current `PageHeaderFooter` element
        private var pageHeaderFooter: PDFBuild.PageHeaderFooter?
        /// The optional `PageCounter` element
        weak var pageCounter: PDFBuild.PageCounter?
        /// All the `PDFElement`'s for the document
        var elements = [PDFElement]()
        /// The Quartz 2D drawing destination
        var pdfContext: CGContext?
        /// The page size of the PDF document
        var pageRect: CGRect = .zero

        /// Init the **builder** class
        /// - Parameter info: The general document information
        init(info: PDFBuild.DocumentInfo) {
            self.document = info
            self.auxiliaryInfo = info.dictionary
        }

        /// Generate a PDF document with all the added elements
        /// - Parameter progress: The closure with progress indication
        /// - Returns: A PDF document as `Data`
        public func generatePdf(
            progress: @escaping (Double) -> Void = { _ in }
        ) -> Data {
            let pdfData = beginPdfContextToData(pageRect: document.pageRect)
            appendPdf(progress: progress)
            endPdfContext()
            return pdfData as Data
        }

        /// Append a page to the PDF document
        /// - Parameter progress: The closure with progress indication
        public func appendPdf(progress: @escaping (Double) -> Void = { _ in }) {
            /// Set the first found `PageHeaderFooter` element, if exists
            if let element = elements.first as? PDFBuild.PageHeaderFooter {
                pageHeaderFooter = element
            }
            /// Start a new page
            var currentRect = beginPage()
            /// Add all elements
            for (index, element) in elements.enumerated() {
                progress(Double(index) / Double(elements.count))
                if let element = element as? PDFBuild.PageHeaderFooter {
                    /// Store the `PageHeaderFooter`; it will be used with the next page
                    pageHeaderFooter = element
                } else {
                    if element.shoudPageBreak(rect: currentRect, pageRect: pageRect) {
                        endPage()
                        currentRect = beginPage()
                    }
                    element.draw(rect: &currentRect, calculationOnly: false, pageRect: pageRect)
                }
            }
        }

        /// Begin a new PDF page
        /// - Returns: The rectangle of the new page
        private func beginPage() -> CGRect {
            beginPdfPage()
            if let pageCounter = pageCounter {
                pageCounter.pageNumber += 1
            }
            var page = document.pageRect.insetBy(dx: document.pagePadding, dy: document.pagePadding)
            pageHeaderFooter?.draw(rect: &page, calculationOnly: false, pageRect: pageRect)
            return page
        }

        /// End the current PDF page
        private func endPage() {
            pdfContext?.endPDFPage()
        }
    }
}

extension PDFBuild.Builder {

    // MARK: OS dependent helper functions

    /// Begin a new PDF page
    func beginPdfPage() {
        let pageInfo = [
            kCGPDFContextMediaBox: document.pageRect
        ] as CFDictionary

        pdfContext?.beginPDFPage(pageInfo)
        /// Scale and translate to flip vertically
        pdfContext?.translateBy(x: 0, y: document.pageRect.height)
        pdfContext?.scaleBy(x: 1.0, y: -1.0)
    }

    /// Begin a new PDF page
    /// - Parameter pageRect: The rectangle of the page
    /// - Returns: The PDF page as `NSMutableData`
    func beginPdfContextToData(pageRect: CGRect) -> NSMutableData {

        /// Set the page size
        self.pageRect = pageRect

        let pdfData = NSMutableData()
        guard
            let pdfConsumer = CGDataConsumer(data: pdfData as CFMutableData),
            let pdfContext = CGContext(consumer: pdfConsumer, mediaBox: &self.pageRect, auxiliaryInfo as CFDictionary)
        else {
            return pdfData
        }
        self.pdfContext = pdfContext
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(cgContext: pdfContext, flipped: true)
        return pdfData
    }

    /// End the current PDF page
    func endPdfContext() {
        endPage()
        pdfContext?.closePDF()
        NSGraphicsContext.restoreGraphicsState()
    }
}
