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
                    Text("Export all \(currentInstrument.label) chords")
                }
            }
            GridRow {
                sceneState.scaleSlider
                    .frame(width: 120)
                Toggle("Hide Correct Chords", isOn: $hideCorrectChords)
                VStack {
                    Button {
                        chordsDatabaseState.showExportSheet.toggle()
                    } label: {
                        Text(.init("Export \(currentInstrument.label) chords to **ChordPro** format"))
                    }
                    Text("Only the first definition of a chord will be exported")
                        .font(.caption)
                }
            }
        }
        .padding()
    }
}
