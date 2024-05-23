//
//  EditorView+directiveButton.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

extension EditorView {

    /// A button to add a directive with the selected text
    func directiveButton(directive: ChordPro.Directive) -> some View {
        Button(
            action: {
                EditorView.format(
                    settings: DirectiveSettings(directive: directive),
                    in: connector
                )
            }, label: {
                Label("\(directive.details.button)…", systemImage: directive.details.icon)
            }
        )
    }
}
