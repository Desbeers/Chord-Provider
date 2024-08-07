//
//  EditorView+validateChordDefinition.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation
import SwiftlyChordUtilities

extension EditorView {

    /// Validate the definition of the chord
    /// - Returns: True or false to show the sheet. If true, the definition will be set or else an alert will be shown
    @MainActor func validateChordDefinition() -> Bool {
        do {
            let chord = try ChordDefinition(
                definition: sceneState.editorInternals.directiveArgument,
                instrument: sceneState.chordDisplayOptions.displayOptions.instrument,
                status: .unknownChord
            )
            /// Set the definition
            sceneState.chordDisplayOptions.definition = chord
            /// Show the sheet
            return true
        } catch {
            /// Show an error alert
            errorAlert = error.alert()
        }
        return false
    }
}
