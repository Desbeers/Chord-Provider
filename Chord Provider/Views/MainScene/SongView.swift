//
//  SongView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for the song
struct SongView: View {
    /// The observable state of the scene
    @Environment(SceneStateModel.self) private var sceneState
    /// The body of the `View`
    var body: some View {
        if sceneState.song.sections.isEmpty {
            ContentUnavailableView("The Song is Empty", systemImage: "music.quarternote.3")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
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
                        .padding(sceneState.settings.song.display.scale * 20)
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
