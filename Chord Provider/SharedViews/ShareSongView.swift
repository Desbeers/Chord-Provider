//
//  ShareSongView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View for the Share Button`
struct ShareSongView: View {
    /// The scene
    @FocusedObject private var sceneSate: SceneState?
    /// The body of the `View`
    var body: some View {
        if let url = sceneSate?.song.exportURL {
            ShareLink(item: url)
                .labelStyle(.iconOnly)
        }
    }
}
