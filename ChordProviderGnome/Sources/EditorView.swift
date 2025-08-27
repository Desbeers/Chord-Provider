//
//  File.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 27/08/2025.
//

import Foundation
import Adwaita
import ChordProviderCore
import ChordProviderHTML

struct EditorView: View {

    @Binding var text: String

    var view: Body {
        TextEditor(text: $text)
            .innerPadding(20)
            .frame(minWidth: 200)
            .card()
    }
}
