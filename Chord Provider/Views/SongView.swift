//
//  SongView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for the song
struct SongView: View {
    /// The scene state
    @EnvironmentObject private var sceneState: SceneState
    /// The minimum scale factor
    private let minScale: Double = 0.8
    /// The maximum scale factor
    private let maxScale: Double = 2.6
    /// Observe the gesture state
    @GestureState private var magnificationState = MagnificationState.inactive
    /// State of the `MagnificationGesture`
    private enum MagnificationState {
        /// No magnification
        case inactive
        /// Magnification ongoing
        case active(scale: Double)
        /// The current scale factor
        var scale: Double {
            switch self {
            case .active(let scale): scale
            default: 1.0
            }
        }
    }
    /// Calculate the scale within the minimum and maximum scale value
    private var scale: Double {
        min(max(sceneState.currentScale * magnificationState.scale, minScale), maxScale)
    }
    /// The `MagnificationGesture`
    var magnificationGesture: some Gesture {
        MagnificationGesture()
            .updating($magnificationState) { value, state, _ in
                state = .active(scale: value)
            }
            .onEnded { value in
                sceneState.currentScale = min(max(sceneState.currentScale * value, minScale), maxScale)
            }
    }
    /// The body of the `View`
    var body: some View {
        VStack {
            ScrollView {
                ViewThatFits {
                    Song.Render(song: sceneState.song, scale: scale, style: .asGrid)
                    Song.Render(song: sceneState.song, scale: scale, style: .asList)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .gesture(magnificationGesture)
    }
}
