//
//  Modifiers+Scale.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension Modifiers {

    /// SwiftUI `Modifier` to scale a `View`
    struct Scale: ViewModifier {
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
}

extension View {

    /// Shortcut to the `WrapSettingsSection` modifier
    /// - Parameter title: The title
    /// - Returns: A modified `View`
    var scaleModifier: some View {
        modifier(Modifiers.Scale())
    }
}
