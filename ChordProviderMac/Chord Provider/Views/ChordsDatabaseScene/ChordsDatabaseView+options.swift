//
//  ChordsDatabaseView+options.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension ChordsDatabaseView {

    /// A `View` with options for the grid
    var options: some View {
        Grid(alignment: .leading) {
            GridRow {
                appState.mirrorToggle
                appState.midiInstrumentPicker
                    .frame(maxWidth: 220)
                Button {
                    chordsDatabaseState.showExportSheet.toggle()
                } label: {
                    Text("Export \(currentInstrument.description) chords")
                }
            }
            GridRow {
                sceneState.scaleSlider
                    .frame(width: 120)
                Toggle("Hide Correct Chords", isOn: $hideCorrectChords)
            }
        }
        .padding()
    }
}
