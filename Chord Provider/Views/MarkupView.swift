//
//  MarkupView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for the markup buttons
struct MarkupView: View {
    /// The scene
    @FocusedObject private var sceneState: SceneState?
    /// The body of the `View`
    var body: some View {
        Group {
            Menu(
                content: {
                    ForEach(ChordPro.Directive.metaDataDirectives, id: \.self) { directive in
                        if sceneState?.selection.length == 0 {
                            EditorView.DirectiveButton(directive: directive)
                        } else {
                            EditorView.EditorButton(directive: directive)
                        }
                    }
                },
                label: {
                    Label("Meta Data", systemImage: "gear")
                }
            )
            Menu(
                content: {
                    ForEach(ChordPro.Directive.environmentDirectives, id: \.self) { directive in
                        EditorView.EditorButton(directive: directive)
                    }
                },
                label: {
                    Label("Enviroment", systemImage: "gear")
                }
            )
            Menu(
                content: {
                    EditorView.DirectiveButton(directive: .define)
                    EditorView.EditorButton(directive: .comment)
                },
                label: {
                    Label("More...", systemImage: "gear")
                }
            )
        }
        .disabled(sceneState?.showEditor == false)
        .menuStyle(.button)
    }
}
