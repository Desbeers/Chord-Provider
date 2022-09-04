//
//  EditorView.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// The View with the text editor
///
/// SwiftUI does not give too many options for it.
struct EditorView: View {
    @Binding var document: ChordProDocument
    var body: some View {
        TextEditor(text: $document.text)
            .font(.custom("HelveticaNeue", size: 18))
            .lineSpacing(5)
            .padding()
    }
}
