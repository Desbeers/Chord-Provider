//
//  ShareButton.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` with the 'share' button'
struct ShareButton: View {
    /// The observable state of the scene
    @Environment(SceneStateModel.self) private var sceneState
    /// Bool to show the share picker
    @State private var showSharePicker: Bool = false
    /// The export URL
    @State private var exportURLS: [URL]?
    /// The body of the `View`
    var body: some View {
        Button(
            action: {
                Task {
                    do {
                        _ = try await sceneState.exportSongToPDF()
                        /// Set the export URLs. First is the source, second the PDF
                        exportURLS = [sceneState.song.metadata.sourceURL, sceneState.song.metadata.exportURL]
                        /// Show the share picker
                        self.showSharePicker = true
                    } catch {
                        sceneState.errorAlert = error.alert()
                    }
                }
            },
            label: {
                Label("Share", systemImage: "square.and.arrow.up")
            }
        )
        .help("Share the PDF")
        .background(
            AppKitUtils.SharingServiceRepresentedView(
                isPresented: $showSharePicker,
                urls: $exportURLS
            )
        )
    }
}
