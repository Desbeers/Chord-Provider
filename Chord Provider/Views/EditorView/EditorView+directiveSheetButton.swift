//
//  EditorView+directiveSheetButton.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

extension EditorView {

    /// A button for the text editor to add a directive with a sheet
    /// - Note: Shown when there is no selection for the directive
    func directiveSheetButton(directive: ChordPro.Directive) -> some View {
        Button(
            action: {
                directiveSettings.directive = directive
                showDirectiveSheet = true
            }, label: {
                Label("\(directive.details.button)…", systemImage: directive.details.icon)
            }
        )
        .disabled(sceneState.song.definedMetaData.contains(directive))
    }
}
