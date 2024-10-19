//
//  SongView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for the song
@MainActor struct SongView: View {
    /// The observable state of the scene
    @Environment(SceneStateModel.self) private var sceneState
    /// The body of the `View`
    var body: some View {
        let _ = print("RENDER SONG")
        return VStack {
            switch sceneState.settings.song.paging {
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
        .contentMargins(.all, sceneState.settings.song.scale * 20, for: .scrollContent)
        .contentShape(Rectangle())
        .scaleModifier
    }
}
