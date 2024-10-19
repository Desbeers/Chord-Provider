//
//  ChordsDatabaseStateModel+Elements.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

// MARK: Toggles

extension ChordsDatabaseStateModel {

    // MARK: Edit chords Toggle

    /// SwiftUI `View` with a `Toggle` to edit chords
    var editChordsToggle: some View {
        EditChordsToggle(chordsDatabaseState: self)
    }
    /// SwiftUI `View` with a `Toggle` to show the whole last chorus when using a *{chorus}* directive
    struct EditChordsToggle: View {
        /// The binding to the observable state of the chord database
        @Bindable var chordsDatabaseState: ChordsDatabaseStateModel
        /// The body of the `View`
        var body: some View {
            HStack(alignment: .top) {
                Image(systemName: "pencil")
                Toggle(isOn: $chordsDatabaseState.editChords) {
                    Text("Edit the chords database")
                    Text("Edit and export the database.")
                }
            }
        }
    }
}
