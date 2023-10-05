//
//  EditorView+directiveMenus.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

extension EditorView {

    /// Menus with **ChordPro** directives
    var directiveMenus: some View {
        Group {
            Menu(
                content: {
                    ForEach(ChordPro.Directive.metaDataDirectives, id: \.self) { directive in
                        if sceneState.selection.length == 0 {
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
                    directiveButton(directive: .comment)
                },
                label: {
                    Label("More...", systemImage: "pencil")
                }
            )
            Picker("Font Size:", selection: $appState.settings.editorFontSize) {
                ForEach(12...24, id: \.self) { value in
                    Text("\(value)px")
                        .tag(value)
                }
            }
            .labelsHidden()
            .frame(maxWidth: 75)
        }
        .menuStyle(.button)
    }
}
