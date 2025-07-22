//
//  PrintPDFButton.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for the C4 Button
struct C64Button: View {
    /// The observable state of the scene
    @FocusedValue(\.sceneState) private var sceneState: SceneStateModel?
    /// The body of the `View`
    var body: some View {
        Button(
            action: {
                Task {
                    if let sceneState {
                        if sceneState.songRender == .c64 {
                            sceneState.songRender = .standard
                        } else {
                            sceneState.songRender = .c64
                            /// Make sure there is no preview open
                            sceneState.preview.data = nil
                        }
                    }
                }
            },
            label: {
                Label("C64 Mode", systemImage: "c.square")
            }
        )
        .help("Show the song in Commodore 64 mode")
        .disabled(sceneState == nil)
    }
}
