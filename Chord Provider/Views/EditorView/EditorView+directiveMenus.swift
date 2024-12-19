//
//  EditorView+directiveMenus.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

extension EditorView {

    /// Menus with **ChordPro** directives
    @ViewBuilder var directiveMenus: some View {
        @Bindable var appState = appState
        Group {
            Menu(
                content: {
                    ForEach(ChordPro.Directive.metadataDirectives, id: \.self) { directive in
                        if sceneState.editorInternals.selectedRange.length == 0 {
                            directiveSheetButton(directive: directive)
                        } else {
                            directiveButton(directive: directive)
                        }
                    }
                },
                label: {
                    Label("Metadata", systemImage: "gear")
                }
            )
            Menu(
                content: {
                    ForEach(ChordPro.Directive.environmentDirectives, id: \.self) { directive in
                        directiveButton(directive: directive)
                    }
                },
                label: {
                    Label("Environment", systemImage: "rectangle.and.pencil.and.ellipsis")
                }
            )
            Menu(
                content: {
                    directiveSheetButton(directive: .define)
                        .disabled(sceneState.editorInternals.selectedRange.length != 0)
                    directiveButton(directive: .comment)
                },
                label: {
                    Label("More...", systemImage: "pencil")
                }
            )
        }
        .menuStyle(.button)
    }
}
