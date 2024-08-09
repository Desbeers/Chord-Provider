//
//  ShareButtonView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` with the 'share' button'
struct ShareButtonView: View {
    /// The scene state
    @Environment(SceneState.self) private var sceneState
    /// Bool to show the share picker
    @State private var showSharePicker: Bool = false
    /// The export URL
    @State private var exportURL: URL?
    /// The body of the `View`
    var body: some View {
        Button(
            action: {
                if sceneState.exportSongToPDF() != nil {
                    /// Set the export URL
                    exportURL = sceneState.exportURL
                    /// Show the share picker
                    self.showSharePicker = true
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
                url: $exportURL
            )
        )
    }
}
