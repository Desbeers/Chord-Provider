//
//  PrintSongView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import PDFKit

struct PrintSongView: View {
    /// The scene
    @FocusedObject private var scene: SceneState?
    /// The document
    @FocusedBinding(\.document)
    private var document: ChordProDocument?
    /// The body of the `View`
    var body: some View {
        Button(
            action: {
                scene?.showPrintDialog = true
            },
            label: {
                Label("Print…", systemImage: "printer")
            }
        )
        .help("Print your song")
        .disabled(document == nil || scene == nil)
    }
}

extension PrintSongView {

    /// Show a Print Dialog fore the current Song
    ///
    /// - Note: Only in use for macOS, on iPadOS, _printing_ is available via the Share Sheet
    ///
    /// - Parameter song: The Song to print
    static func printDialog(song: Song) {
#if os(macOS)
        if let window = NSApp.keyWindow {
            /// Set the print info
            let printInfo = NSPrintInfo()
            /// Looks like we have to scale down, don't know why but this makes it fit
            printInfo.scalingFactor = 0.72
            /// Build the PDF View
            let pdfView = PDFView()
            pdfView.document = PDFDocument(url: song.exportURL)
            pdfView.minScaleFactor = 0.1
            pdfView.maxScaleFactor = 5
            pdfView.autoScales = true
            /// Attach the PDF View to the Window
            window.contentView?.addSubview(pdfView)
            /// Show the sheet
            pdfView.print(with: printInfo, autoRotate: false)
            /// Remove the sheet
            pdfView.removeFromSuperview()
        }
#endif
    }
}
