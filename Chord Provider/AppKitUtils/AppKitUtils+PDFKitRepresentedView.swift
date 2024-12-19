//
//  PDFKitRepresentedView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
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
            let position = PDFParameters(
                pageIndex: document.index(for: page),
                zoom: currentDestination.zoom,
                location: currentDestination.point
            )
            /// Update the document
            pdfView.document = PDFDocument(data: data)
            /// Restore the view parameters
            if let restoredPage = document.page(at: position.pageIndex) {
                let restoredDestination = PDFDestination(page: restoredPage, at: position.location)
                restoredDestination.zoom = position.zoom
                pdfView.go(to: restoredDestination)
            }
            pdfView.animator().isHidden = false
        }
    }
}

extension AppKitUtils.PDFKitRepresentedView {

    /// The view parameters of a PDF
    struct PDFParameters {
        /// The page index
        let pageIndex: Int
        /// The zoom factor
        let zoom: CGFloat
        /// The location on the page
        let location: NSPoint
    }
}
