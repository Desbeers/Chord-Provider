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
    /// The scaling of the `View`
    let scale: AppSettings.Scale
    /// The body of the `View`
    var body: some View {
        RenderView.MainView(
            song: song,
            scale: scale
        )
        .contentShape(Rectangle())
        .scaleModifier
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        /// Set the standard scaled font
        .font(song.settings.style.fonts.text.swiftUIFont(scale: scale.magnifier))
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
