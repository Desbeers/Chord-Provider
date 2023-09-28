//
//  SceneState.swift
//  Chord Provider (macOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI

/// The observable scene state for Chord Provider
final class SceneState: ObservableObject {
    /// The current ``Song``
    @Published var song = Song(instrument: .guitarStandardETuning)
    /// The Song rendered as PDF
    var pdf: Data = Data()
    /// The selection in the editor
    @Published var selection: NSRange = .init(location: 0, length: 0)
    /// The `NSTextView` of the editor
    var textView: SWIFTTextView?

    /// Bool to show the song chords
    @Published var showChords: Bool = true
    /// Bool to show the editor
    @Published var showEditor: Bool = false

    /// Bool to show the `print` Dialog
    @Published var showPrintDialog: Bool = false
    /// Bool to show the ``EditorView/DirectiveSheet``
    @Published var showDirectiveSheet: Bool = false
    /// The directive to show in the sheet
    var directive: ChordPro.Directive = .define
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
