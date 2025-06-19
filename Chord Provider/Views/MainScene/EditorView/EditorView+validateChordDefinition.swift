//
//  EditorView+validateChordDefinition.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension EditorView {

    /// Validate the definition of the chord
    /// - Returns: True or false to show the sheet. If true, the definition will be set or else an alert will be shown
    func validateChordDefinition() -> Bool {
        dump(sceneState.editorInternals.currentLine)
        do {
            let chord = try ChordDefinition(
                definition: sceneState.editorInternals.directiveArgument,
                instrument: sceneState.song.settings.display.instrument,
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
