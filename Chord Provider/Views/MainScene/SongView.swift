//
//  SongView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for the song
struct SongView: View {
    /// The ``Song``
    let song: Song
    /// The body of the `View`
    var body: some View {
        RenderView.MainView(song: song)
        .contentShape(Rectangle())
        .scaleModifier
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        /// Set the standard scaled font
        .font(song.settings.style.fonts.text.swiftUIFont(scale: song.settings.scale.magnifier))
        .contentShape(.dragPreview, RoundedRectangle(cornerRadius: 8))
        .draggable(song) {
            VStack {
                Text(song.metadata.title)
                    .font(.title2)
                ImageUtils.applicationIcon()
                Text("You are dragging the content of your song")
                    .font(.caption)
            }
            .padding()
            .background(.regularMaterial)
        }
    }
}
