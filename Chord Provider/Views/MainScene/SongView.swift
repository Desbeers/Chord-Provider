//
//  SongView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import ChordProviderCore

/// SwiftUI `View` for the song
struct SongView: View {
    /// The ``Song``
    let song: Song
    /// The ``AppSettings``
    let settings: AppSettings
    /// The state of the song
    @State private var status: SceneStateModel.Status = .loading
    /// The body of the `View`
    var body: some View {
        VStack {
            switch status {
            case .loading:
                EmptyView()
            case .ready:
                RenderView.MainView(song: song, settings: settings)
                .contentShape(Rectangle())
                .scaleModifier
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                /// Set the standard scaled font
                .font(settings.style.fonts.text.swiftUIFont(scale: settings.scale.magnifier))
                /// Set the standard color
                .foregroundStyle(settings.style.theme.foreground)
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
                ContentUnavailableView("The song has no content", systemImage: "music.quarternote.3")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundStyle(
                        settings.style.fonts.text.color,
                        settings.style.theme.foregroundMedium
                    )
            }
        }
        .animation(.default, value: status)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task(id: song.hasContent) {
            status = song.hasContent ? .ready : .error
        }
    }
}
