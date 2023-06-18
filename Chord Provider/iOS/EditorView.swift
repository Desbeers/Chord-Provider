//
//  EditorView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import HighlightedTextEditor

/// SwiftUI `View` for the editor
struct EditorView: View {
    /// The CordPro document
    @Binding var document: ChordProDocument
    /// The body of the `View`
    var body: some View {
        HighlightedTextEditor(text: $document.text, highlightRules: EditorView.rules)
    }
}
