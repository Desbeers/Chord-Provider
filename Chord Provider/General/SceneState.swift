//
//  SceneState.swift
//  Chord Provider (macOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

/// The observable scene state for Chord Provider
@Observable
final class SceneState {
    /// The current ``Song``
    var song = Song(instrument: .guitarStandardETuning)
    /// The selection in the editor
    var selection: NSRange = .init(location: 0, length: 0)
    /// The `NSTextView` of the editor
    var textView: SWIFTTextView?
    /// Bool to show the `print` dialog (macOS)
    var showPrintDialog: Bool = false
    /// The optional file location
    var file: URL?
    /// Show settings (not for macOS)
    var showSettings: Bool = false
    /// Show inspector
    var showInspector: Bool = false
    /// Present template sheet
    var presentTemplate: Bool = false
    /// The data of the PDF export
    var pdfData: Data?

    // MARK: Song View options

    /// The current magnification scale
    var currentScale: Double = 1.0
    /// Bool to show the editor or not
    var showEditor: Bool = false
}


/// The `FocusedValueKey` for the scene state
struct SceneFocusedValueKey: FocusedValueKey {
    /// The `typealias` for the key
    typealias Value = SceneState
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
    typealias Value = ChordProDocument
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
