//
//  ChordDiagramView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for a chord diagram
struct ChordDiagramView: View {
    /// The chord
    let chord: ChordDefinition
    /// Width of the chord diagram
    var width: Double
    /// The current color scheme
    @Environment(\.colorScheme) var colorScheme
    /// The observable state of the application
    @Environment(AppStateModel.self) private var appState
    /// The observable state of the scene
    @Environment(SceneStateModel.self) private var sceneState
    /// The body of the `View`
    var body: some View {
        ChordDefinitionView(
            chord: chord,
            width: width,
            settings: appState.settings
        )
        .foregroundStyle(
            .primary,
            colorScheme == .dark ? .black : .white
        )
        .animation(.default, value: appState.settings.diagram)
    }
}
