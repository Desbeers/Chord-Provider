//
//  EditorView+directiveSheetButton.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

extension EditorView {

    /// A button for the text editor to add a directive with a sheet
    /// - Note: Shown when there is no selection for the directive
    func directiveSheetButton(directive: ChordPro.Directive) -> some View {
        Button(
            action: {
                /// If the directive is `define`, set the definition for a chord to its initial values
                if
                    directive == .define,
                    let chord = ChordDefinition(
                        name: "C",
                        instrument: appState.settings.chordDisplayOptions.instrument
                    ) {
                    sceneState.chordDisplayOptions.definition = chord
                }
                editDirective = directive
            }, label: {
                Label("\(directive.details.button)…", systemImage: directive.details.icon)
            }
        )
        .disabled(sceneState.song.definedMetaData.contains(directive))
    }
}
