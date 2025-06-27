//
//  PDFKitRepresentedView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import PDFKit
import Quartz

extension AppKitUtils {

    /// SwiftUI `NSViewRepresentable` for a PDF View
    struct PDFKitRepresentedView: NSViewRepresentable {
        /// The data of the PDF
        let data: Data
        /// Make the `View`
        /// - Parameter context: The context
        /// - Returns: The PDFView
        func makeNSView(context: NSViewRepresentableContext<PDFKitRepresentedView>) -> PDFView {
            /// Create a `PDFView` and set its `PDFDocument`.
            let pdfView = PDFView()
            pdfView.document = PDFDocument(data: data)
            /// Auto scale the PDF
            pdfView.autoScales = true
            return pdfView
        }
        /// Update the `View`
        /// - Parameters:
        ///   - pdfView: The PDFView
        ///   - context: The context
        func updateNSView(_ pdfView: PDFView, context: NSViewRepresentableContext<PDFKitRepresentedView>) {
            /// Animate the transition
            pdfView.animator().isHidden = true
            /// Make sure we have a document with a page
            guard
                let currentDestination = pdfView.currentDestination,
                let page = currentDestination.page,
                let document = pdfView.document
            else {
                return
            }
            /// Save the view parameters
            let pageIndex = document.index(for: page)
            let point = currentDestination.point
            /// Update the document
            pdfView.document = PDFDocument(data: data)
            /// Restore the view parameters
            if let restoredPage = pdfView.document?.page(at: pageIndex) {
                let restoredDestination = PDFDestination(page: restoredPage, at: point)
                pdfView.go(to: restoredDestination)
            }
            pdfView.animator().isHidden = false
        }
    }
}
