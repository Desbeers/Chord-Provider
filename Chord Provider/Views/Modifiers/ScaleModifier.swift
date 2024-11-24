//
//  ScaleModifier.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

@MainActor struct ScaleModifier: ViewModifier {
    /// The observable state of the scene
    @Environment(SceneStateModel.self) private var sceneState
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
        min(max(sceneState.settings.song.display.scale * magnificationState.scale * 0.5, minScale), maxScale)
    }
    /// The `MagnifyGesture`
    private var magnifyGesture: some Gesture {
        MagnifyGesture()
            .updating($magnificationState) { value, state, _ in
                state = .active(scale: value.magnification)
            }
            .onEnded { value in
                sceneState.settings.song.display.scale = min(max(sceneState.settings.song.display.scale * value.magnification, minScale), maxScale)
            }
    }
    /// The `TapGesture`
    private var doubleTapGesture: some Gesture {
        TapGesture(count: 2).onEnded {
            withAnimation {
                sceneState.settings.song.display.scale = min(max(sceneState.settings.song.display.scale + 0.2, minScale), maxScale)
            }
        }
    }

    func body(content: Content) -> some View {
        content
            .gesture(ExclusiveGesture(magnifyGesture, doubleTapGesture))
            .onLongPressGesture(minimumDuration: 1) {
                withAnimation {
                    sceneState.settings.song.display.scale = min(max(sceneState.settings.song.display.scale - 0.2, minScale), maxScale)
                }
            }
    }
}

extension View {

    /// Shortcut to the `WrapSettingsSection` modifier
    /// - Parameter title: The title
    /// - Returns: A modified `View`
    var scaleModifier: some View {
        modifier(ScaleModifier())
    }
}
