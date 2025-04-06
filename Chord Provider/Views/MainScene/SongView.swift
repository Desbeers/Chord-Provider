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
        if sceneState.song.sections.isEmpty {
            ContentUnavailableView("The Song is Empty", systemImage: "music.quarternote.3")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            ZStack {
                /// Get the max size
                Text(sceneState.song.metadata.longestLine)
                    .onGeometryChange(for: CGSize.self) { proxy in
                        proxy.size
                    } action: { newValue in
                        if newValue.width + 40 > 340 {
                            sceneState.song.maxWidth = newValue.width + 40
                        }
                    }
                    .font(appState.settings.style.fonts.text.swiftUIFont(scale: sceneState.song.scale))
                    .hidden()
                VStack {
                    switch sceneState.settings.song.display.paging {
                    case .asList:
                        ScrollView {
                            ViewThatFits {
                                RenderView(
                                    song: sceneState.song,
                                    paging: .asList,
                                    labelStyle: .grid
                                )
                                RenderView(
                                    song: sceneState.song,
                                    paging: .asList,
                                    labelStyle: .inline
                                )
                            }
                            .padding(sceneState.song.scale * 20)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    case .asColumns:
                        RenderView(
                            song: sceneState.song,
                            paging: .asColumns,
                            labelStyle: .inline
                        )
                    }
                }
                .contentShape(Rectangle())
                .scaleModifier
            }
        }
    }
}
