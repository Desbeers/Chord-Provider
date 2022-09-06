//
//  EditorView.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI

struct EditorView: View {
    @Binding var document: ChordProDocument
    var body: some View {
        TextEditor(text: $document.text)
            .font(.custom("Andale Mono", size: 18))
            .lineSpacing(5)
            .padding()
    }
}
