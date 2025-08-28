//
//  File.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore
import ChordProviderHTML

struct EditorView: View {

    @Binding var text: String

    var view: Body {
        ScrollView {
            TextEditor(text: $text)
                .innerPadding(20)
        }
            .frame(minWidth: 200)
            .card()
    }
}
