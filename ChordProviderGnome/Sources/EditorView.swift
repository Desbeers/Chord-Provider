//
//  File.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import SourceView
import ChordProviderCore
import ChordProviderHTML

struct EditorView: View {

    @Binding var text: String

    var view: Body {
        VStack(spacing: 0) {
            ScrollView {
                SourceView(text: $text)
                    .innerPadding()
                    .lineNumbers()
                    .language(.chordpro)
                    .vexpand()
//                    .card()
                    .padding()
                    .css {
                        "textview { font-family: Monospace; font-size: 12pt; }"
                    }
            }
        }
    }
}
