//
//  EditorView+validateChordDefinition.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation
import SwiftlyChordUtilities

extension EditorView {
    
    /// Validate the definition of the chord
    /// - Returns: True or false to show the sheet. If true, the definition will be set or else an alert will be shown
    func validateChordDefinition() -> Bool {
        guard
            let chord = ChordDefinition(
                definition: directiveSettings.definition,
                instrument: chordDisplayOptions.displayOptions.instrument,
                status: .unknown
            )
        else {
            /// Clear the settings to default
            directiveSettings = DirectiveSettings()
            connector.textView.clickedFragment = nil
            /// Show an error message
            errorAlert = ChordProviderError.wrongChordDefinitionError.alert()
            /// Don't show the sheet
            return false
        }
        /// Set the definition
        chordDisplayOptions.definition = chord
        /// Show the sheet
        return true
    }
}
