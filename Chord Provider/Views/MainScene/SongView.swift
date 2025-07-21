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
    /// The state of the song
    @State private var status: SceneStateModel.Status = .loading
    /// The body of the `View`
    var body: some View {
        VStack {
            switch status {
            case .loading:
                EmptyView()
            case .ready:
                RenderView.MainView(song: song)
                .contentShape(Rectangle())
                .scaleModifier
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                /// Set the standard scaled font
                .font(song.settings.style.fonts.text.swiftUIFont(scale: song.settings.scale.magnifier))
                /// Set the standard color
                .foregroundStyle(song.settings.style.theme.foreground)
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
            case .error:
                Text("error")
            }
        }
        .animation(.default, value: status)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task(id: song.settings.scale.maxSongWidth) {
            status = song.settings.scale.maxSongWidth > 0 ? .ready : .loading
        }
    }
}
