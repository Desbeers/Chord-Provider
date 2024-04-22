//
//  ExportLibraryView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities
import PDFKit

struct ExportLibraryView: View {
    /// The FileBrowser model
    @Environment(FileBrowser.self) private var fileBrowser
    /// Chord Display Options
    @Environment(ChordDisplayOptions.self) private var chordDisplayOptions
    /// Present an export dialog
    @State private var exportFile = false
    /// The library as PDF
    @State private var pdf: Data?
    /// The body of the `View`
    var body: some View {
        // swiftlint:disable:next trailing_closure
        Button(
            action: {
                let render = libraryExport(files: fileBrowser.songList, options: chordDisplayOptions.displayOptions)
                /// Process the PDF data
                if let result = SongToPDF.process(data: render.pdf, toc: render.toc) {
                    pdf = result.dataRepresentation()
                    /// Show the export dialog
                    exportFile = true
                }
            },
            label: {
                Label("Export Library…", systemImage: "square.and.arrow.up")
            }
        )
        .help("Export your library as PDF")
        .disabled(fileBrowser.songsFolder == nil)
        .fileExporter(
            isPresented: $exportFile,
            document: ExportDocument(pdf: pdf),
            contentType: .pdf,
            defaultFilename: fileBrowser.songsFolder?.lastPathComponent,
            onCompletion: { result in
                if case .success = result {
                    print("Success")
                } else {
                    print("Failure")
                }
            }
        )
    }
}
