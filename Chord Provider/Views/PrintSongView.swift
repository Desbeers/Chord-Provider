//
//  PrintSongView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import PDFKit

/// SwiftUI `View` for the Print Button
struct PrintSongView: View {
    /// The scene
    @FocusedValue(\.scene)
    private var sceneState: SceneState?
    /// The body of the `View`
    var body: some View {
        Button(
            action: {
                if let sceneState {
                    /// Show the print dialog
                    sceneState.showPrintDialog = true
                }
            },
            label: {
                Label("Print…", systemImage: "printer")
            }
        )
        .help("Print your song")
        .disabled(sceneState == nil)
    }
}

extension PrintSongView {

    /// Show a Print Dialog for the current ``Song``
    /// - Parameter song: The ``Song`` to print
    @MainActor static func printDialog(song: Song, exportURL: URL) {
        if let window = NSApp.keyWindow {
            /// Set the print info
            let printInfo = NSPrintInfo()
            /// Build the PDF View
            let pdfView = PDFView()
            pdfView.document = PDFDocument(url: exportURL)
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
    }
}
