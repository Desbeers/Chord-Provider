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
        VStack(spacing: 0) {
            ScrollView {
                TextEditor(text: $text)
                    .innerPadding(20)
                    .vexpand()
                    .card()
                    .padding()
            }
        }
    }
}
