//
//  ExportSongView.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// SwiftUI `Button` to export a song
struct ExportSongView: View {
    /// The ``Song``
    let song: Song
    /// Present an export dialog
    @State private var exportFile = false
    /// The song as image
    @State private var image: NSData?
    /// The body of the `View`
    var body: some View {
        Button(action: {
            renderSong()
        }, label: {
            Label("Export song", systemImage: "square.and.arrow.up")
        })
        .labelStyle(.iconOnly)
        .help("Export your song")
        .fileExporter(
            isPresented: $exportFile,
            document: ChordProviderDocument(image: image),
            contentType: .pdf,
            defaultFilename: "\(song.artist ?? "Artist") - \(song.title ?? "Title")",
            onCompletion: { result in
                if case .success = result {
                    print("Success")
                } else {
                    print("Failure")
                }
            }
        )
    }

    /// Render the song as a PDF
    @MainActor private func renderSong() {
        if let pdf = ExportSong.createPDF(song: song) {
            image = pdf
            exportFile = true
        }
    }
}
