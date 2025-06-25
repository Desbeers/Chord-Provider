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
                /// Get the size of the longest song line
                /// - Note: This is not perfect but seems well enough for normal songs
                RenderView.PartsView(
                    song: sceneState.song,
                    sectionID: -100,
                    parts: sceneState.song.metadata.longestLine.parts ?? [],
                    chords: sceneState.song.chords
                )
                .onGeometryChange(for: CGSize.self) { proxy in
                    proxy.size
                } action: { newValue in
                    sceneState.song.settings.maxWidth = newValue.width > 340 ? newValue.width : 340
                }
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
