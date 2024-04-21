//
//  PDFKitRepresentedView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

import PDFKit

#if os(macOS)

/// SwiftUI `NSViewRepresentable` for a PDF View
struct PDFKitRepresentedView: NSViewRepresentable {
    typealias NSViewType = PDFView
    /// The data of the View
    let data: Data
    /// Bool to show the PDF as single page
    let singlePage: Bool
    /// Init the View
    init(data: Data, singlePage: Bool = false) {
        self.data = data
        self.singlePage = singlePage
    }

    /// Malke the View
    /// - Parameter context: The context
    /// - Returns: The PDFView
    func makeNSView(context _: NSViewRepresentableContext<PDFKitRepresentedView>) -> NSViewType {
        /// Create a `PDFView` and set its `PDFDocument`.
        let pdfView = PDFView()
        pdfView.document = PDFDocument(data: data)
        pdfView.autoScales = true
        if singlePage {
            pdfView.displayMode = .singlePage
        }
        return pdfView
    }

    /// Update the View
    /// - Parameters:
    ///   - pdfView: The PDGView
    ///   - context: The context
    func updateNSView(_ pdfView: NSViewType, context _: NSViewRepresentableContext<PDFKitRepresentedView>) {
        pdfView.document = PDFDocument(data: data)
    }
}

#else

/// SwiftUI `UIViewRepresentable` for a PDF View
struct PDFKitRepresentedView: UIViewRepresentable {

    typealias UIViewType = PDFView
    /// The data of the View
    let data: Data
    /// Bool to show the PDF as single page
    let singlePage: Bool
    /// Init the View
    init(data: Data, singlePage: Bool = false) {
        self.data = data
        self.singlePage = singlePage
    }

    /// Malke the View
    /// - Parameter context: The context
    /// - Returns: The PDFView
    func makeUIView(context _: UIViewRepresentableContext<PDFKitRepresentedView>) -> UIViewType {
        /// Create a `PDFView` and set its `PDFDocument`.
        let pdfView = PDFView()
        pdfView.document = PDFDocument(data: data)
        pdfView.autoScales = true
        if singlePage {
            pdfView.displayMode = .singlePage
        }
        return pdfView
    }

    /// Update the View
    /// - Parameters:
    ///   - pdfView: The PDGView
    ///   - context: The context
    func updateUIView(_ pdfView: UIViewType, context _: UIViewRepresentableContext<PDFKitRepresentedView>) {
        pdfView.document = PDFDocument(data: data)
    }
}

#endif
