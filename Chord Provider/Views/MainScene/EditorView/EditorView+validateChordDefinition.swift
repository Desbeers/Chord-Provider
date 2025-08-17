//
//  EditorView+validateChordDefinition.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension EditorView {

    /// Validate the definition of the chord
    /// - Returns: True or false to show the sheet. If true, the definition will be set or else an alert will be shown
    func validateChordDefinition() -> Bool {
        guard let definition = sceneState.editorInternals.currentLine.plain else {
            return false
        }
        do {
            let chord = try ChordDefinition(
                definition: definition,
                instrument: sceneState.song.metadata.instrument,
                status: .unknownChord
            )
            /// Set the definition
            sceneState.definition = chord
            /// Show the sheet
            return true
        } catch {
            /// Show an error alert
            sceneState.errorAlert = error.alert()
        }
        return false
    }
}
