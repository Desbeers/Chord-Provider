//
//  EditorView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for the editor
struct EditorView: View {
    /// The CordPro document
    @Binding var document: ChordProDocument
    /// The body of the `View`
    var body: some View {
        TextEditor(text: $document.text)
            .font(.custom("Andale Mono", size: 18))
            .lineSpacing(5)
            .padding()
    }
}
