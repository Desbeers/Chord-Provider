//
//  EditorView.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 03/12/2020.
//

import SwiftUI

struct EditorView: View {
    
    @Binding var text: String
    
    var body: some View {
        TextEditor(text: $text)
            .font(.custom("HelveticaNeue", size: 14))
            .padding()
    }
}
