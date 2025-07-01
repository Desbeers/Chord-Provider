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
    @Environment(SceneStateModel.self) var sceneState
    //    /// The ``Song``
    //    let song: Song
    //
    //    let scale: Double
    //    /// Max width of the `View`
    //    @State private var maxWidth: Double = 340
    //
    //    /// Max width of the  label`View`
    //    @State private var maxLabelWidth: Double = 100

    /// The body of the `View`
    var body: some View {
        let _ = Self._printChanges()
        VStack {
            switch sceneState.song.settings.display.paging {
            case .asList:
                ScrollView {
                    RenderView.MainView(
                        song: sceneState.song,
                        scale: sceneState.scale
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
            case .asColumns:
                RenderView.MainView(
                    song: sceneState.song,
                    scale: sceneState.scale
                )
            }
        }
        .contentShape(Rectangle())
        .scaleModifier
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        /// Set the standard scaled font
        .font(sceneState.song.settings.style.fonts.text.swiftUIFont(scale: sceneState.scale.scale))
    }
}
