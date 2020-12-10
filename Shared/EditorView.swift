//
//  EditorView.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 03/12/2020.
//

import SwiftUI

struct EditorView: View {
    
    @Binding var document: ChordProDocument
    @Binding var diagrams: [Diagram]
    @Binding var song: Song
    
    @AppStorage("showChords") var showChords: Bool = true
    
    var body: some View {
        TextEditor(text: $document.text)
            .font(.custom("HelveticaNeue", size: 14))
            .padding()
            .onChange(of: document.text) { newValue in
                song = ChordPro.parse(document: document, diagrams: diagrams)
                print("Text is changed")
            }
    }
}
