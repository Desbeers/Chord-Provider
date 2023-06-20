//
//  SceneState.swift
//  Chord Provider (macOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI

final class SceneState: ObservableObject {
    @Published var selection: NSRange = .init(location: 0, length: 0)
    var textView: NSTextView?
}

struct SceneFocusedValueKey: FocusedValueKey {
    typealias Value = Binding<SceneState>
}

extension FocusedValues {
    var scene: SceneFocusedValueKey.Value? {
        get {
            self[SceneFocusedValueKey.self]
        }
        set {
            self[SceneFocusedValueKey.self] = newValue
        }
    }
}

struct DocumentFocusedValueKey: FocusedValueKey {
    typealias Value = Binding<ChordProDocument>
}

extension FocusedValues {
    var document: DocumentFocusedValueKey.Value? {
        get {
            self[DocumentFocusedValueKey.self]
        }
        set {
            self[DocumentFocusedValueKey.self] = newValue
        }
    }
}

struct MarkupCommands: Commands {
    var body: some Commands {
        CommandMenu("Markup") {
            Menu(
                content: {
                    EditorView.EditorButton(directive: .startOfVerse)
                    EditorView.EditorButton(directive: .startOfChorus)
                    EditorView.EditorButton(directive: .chorus)
                    EditorView.EditorButton(directive: .startOfTab)
                    EditorView.EditorButton(directive: .startOfGrid)
                    EditorView.EditorButton(directive: .startOfBridge)
                },
                label: {
                    Label("Enviroment directives", systemImage: "gear")
                }
            )
            Divider()
            Menu(
                content: {
                    EditorView.EditorButton(directive: .comment)
                    EditorView.EditorButton(directive: .define)
                },
                label: {
                    Label("More...", systemImage: "gear")
                }
            )
        }
    }
}
