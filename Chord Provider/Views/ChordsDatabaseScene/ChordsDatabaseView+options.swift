//
//  ChordsDatabaseView+options.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import OSLog

extension ChordsDatabaseView {

    /// A `View` with options for the grid
    var options: some View {
        Grid(alignment: .leading) {
            GridRow {
                appState.mirrorToggle
                appState.midiInstrumentPicker
                    .frame(maxWidth: 220)
                Button {
                    do {
                        chordsDatabaseState.exportData = try Chords.exportToJSON(
                            definitions: chordsDatabaseState.allChords,
                            uniqueNames: false
                        )
                        chordsDatabaseState.showExportSheet.toggle()
                    } catch {
                        Logger.application.error("\(error.localizedDescription, privacy: .public)")
                    }
                } label: {
                    Text("Export all \(sceneState.settings.song.display.instrument) chords")
                }
            }
            GridRow {
                sceneState.scaleSlider
                    .frame(width: 120)
                Spacer()
                VStack {
                    Button {
                        do {
                            chordsDatabaseState.exportData = try Chords.exportToJSON(
                                definitions: chordsDatabaseState.allChords,
                                uniqueNames: true
                            )
                            chordsDatabaseState.showExportSheet.toggle()
                        } catch {
                            Logger.application.error("\(error.localizedDescription, privacy: .public)")
                        }
                    } label: {
                        Text(.init("Export \(sceneState.settings.song.display.instrument) chords to **ChordPro** format"))
                    }
                    Text("Only the first definition of a chord will be exported")
                        .font(.caption)
                }
            }
        }
        .padding()
    }
}
