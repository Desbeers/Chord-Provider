//
//  ChordDiagramView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

/// SwiftUI `View` for a chord diagram
struct ChordDiagramView: View {
    /// The chord
    let chord: ChordDefinition
    /// Width of the chord diagram
    var width: Double
    /// The current color scheme
    @Environment(\.colorScheme) var colorScheme
    /// Chord Display Options
    @Environment(ChordDisplayOptions.self) private var chordDisplayOptions
    /// The body of the `View`
    var body: some View {
        ChordDefinitionView(
            chord: chord,
            width: width,
            options: chordDisplayOptions.displayOptions
        )
        .foregroundStyle(
            .primary,
            colorScheme == .dark ? .black : .white
        )
            .animation(.default, value: chordDisplayOptions.displayOptions)
    }
}
