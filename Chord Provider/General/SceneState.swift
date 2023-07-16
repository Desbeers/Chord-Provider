//
//  SceneState.swift
//  Chord Provider (macOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI

/// The observable scene state for Chord Provider
final class SceneState: ObservableObject {
    /// The selection in the editor
    @Published var selection: NSRange = .init(location: 0, length: 0)

    @Published var pdf: Data = Data()

    /// The `NSTextView` of the editor
    var textView: SWIFTTextView?
    /// Bool to show the `print` Dialog
    @Published var showPrintDialog: Bool = false
}

/// The `FocusedValueKey` for the scene state
struct SceneFocusedValueKey: FocusedValueKey {
    /// The `typealias` for the key
    typealias Value = Binding<SceneState>
}

extension FocusedValues {
    /// The value of the scene state key
    var scene: SceneFocusedValueKey.Value? {
        get {
            self[SceneFocusedValueKey.self]
        }
        set {
            self[SceneFocusedValueKey.self] = newValue
        }
    }
}

/// The `FocusedValueKey` for the current document
struct DocumentFocusedValueKey: FocusedValueKey {
    /// The `typealias` for the key
    typealias Value = Binding<ChordProDocument>
}

extension FocusedValues {
    /// The value of the document key
    var document: DocumentFocusedValueKey.Value? {
        get {
            self[DocumentFocusedValueKey.self]
        }
        set {
            self[DocumentFocusedValueKey.self] = newValue
        }
    }
}

/// SwiftUI `Commands` for editing the document
struct MarkupCommands: Commands {
    /// The Body of the `Commands`
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
