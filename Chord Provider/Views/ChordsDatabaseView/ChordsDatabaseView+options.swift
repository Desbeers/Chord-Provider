//
//  ChordsDatabaseView+options.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 19/10/2024.
//

import SwiftUI

extension ChordsDatabaseView {
    var options: some View {
        Grid(alignment: .leading) {
            GridRow {
                appState.mirrorToggle
                appState.playToggle
                chordsDatabaseState.editChordsToggle


            }
            GridRow {

                appState.notesToggle

                appState.midiInstrumentPicker
                    .frame(maxWidth: 220)
                Button {
                    do {
                        chordsDatabaseState.exportData = try Chords.exportToJSON(definitions: chordsDatabaseState.allChords)
                        chordsDatabaseState.showExportSheet.toggle()
                    } catch {
                        print(error)
                    }
                } label: {
                    Text("Export Chords to **ChordPro** format")
                }
            }
        }
        .padding()
    }
}
