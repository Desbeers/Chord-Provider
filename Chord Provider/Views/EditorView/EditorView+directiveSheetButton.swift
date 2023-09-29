//
//  EditorView+directiveSheetButton.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

extension EditorView {

    /// A button for the text editor to add a directive with a sheet
    func directiveSheetButton(directive: ChordPro.Directive) -> some View {
        Button(
            action: {
                self.directive = directive
                showDirectiveSheet = true
            }, label: {
                Label("\(directive.label.text)…", systemImage: directive.label.icon)
            }
        )
    }
}
