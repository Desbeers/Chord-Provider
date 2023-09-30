//
//  ShareSongView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import PDFKit

/// SwiftUI `View` for the Share Button
struct ShareSongView: View {
    /// The scene state
    @EnvironmentObject private var sceneState: SceneState
    /// The body of the `View`
    var body: some View {
        ShareLink(item: sceneState.song.exportURL)
            .labelStyle(.iconOnly)
    }
}
