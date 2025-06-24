//
//  SongView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for the song
struct SongView: View {
    /// The observable state of the application
    @Environment(AppStateModel.self) private var appState
    /// The observable state of the scene
    @Environment(SceneStateModel.self) private var sceneState
    /// The body of the `View`
    var body: some View {
        if sceneState.song.hasContent {
            ZStack {
                /// Get the max size
                /// - Note: This is not perfect but seems well enough for normal songs
                Text(sceneState.song.metadata.longestLine)
                    .onGeometryChange(for: CGSize.self) { proxy in
                        proxy.size
                    } action: { newValue in
                        if newValue.width + (40 * sceneState.song.settings.scale) > 340 {
                            sceneState.song.settings.maxWidth = newValue.width + (40 * sceneState.song.settings.scale)
                        }
                    }
                    .font(appState.settings.style.fonts.text.swiftUIFont(scale: sceneState.song.settings.scale))
                    .hidden()
                VStack {
                    switch sceneState.song.settings.display.paging {
                    case .asList:
                        ScrollView {
                            /// - Note: Try if a *grid* label will fit; else show it inline
                            ViewThatFits {
                                RenderView(
                                    song: sceneState.song,
                                    labelStyle: .grid
                                )
                                RenderView(
                                    song: sceneState.song,
                                    labelStyle: .inline
                                )
                            }
                            .padding(sceneState.song.settings.scale * 20)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    case .asColumns:
                        RenderView(
                            song: sceneState.song,
                            labelStyle: .inline
                        )
                    }
                }
                .contentShape(Rectangle())
                .scaleModifier
            }
        } else {
            ContentUnavailableView("The song has no content", systemImage: "music.quarternote.3")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
