//
//  Views+Editor.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import SourceView
import ChordProviderCore

extension Views {

    /// The `View` for editing a song
    struct Editor: View {
        /// The state of the application
        @Binding var appState: AppState
        /// The body of the `View`
        var view: Body {
            VStack(spacing: 0) {
                ScrollView {
                    SourceView(text: $appState.scene.source)
                        .innerPadding()
                        .lineNumbers(appState.settings.editor.showLineNumbers)
                        .language(.chordpro)
                        .wrapMode(appState.settings.editor.wrapLines ? .word : .none)
                        .highlightCurrentLine(true)
                        .vexpand()
                        .css {
                            "textview { font-family: Monospace; font-size: \(appState.settings.editor.fontSize.rawValue)pt; }"
                        }
                        .card()
                        .padding(8)
                }
            }
        }
    }
}
