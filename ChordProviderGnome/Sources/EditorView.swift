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

    @Binding var settings: AppSettings

    var view: Body {
        VStack(spacing: 0) {
            ScrollView {
                SourceView(text: $settings.app.source)
                    .innerPadding()
                    .lineNumbers()
                    .language(.chordpro)
                    .vexpand()
                    .css {
                        "textview { font-family: Monospace; font-size: 12pt; }"
                    }
                    .card()
                    .padding(8)
            }
            HStack {
                Button("Clean Source") {
                    let song = Song(id: UUID(), content: settings.app.source)
                    let result = ChordProParser.parse(
                        song: song,
                        settings: settings.core
                    )
                    settings.app.source = result.sections.flatMap(\.lines).map(\.sourceParsed).joined(separator: "\n")
                }
                .padding(4)
            }
            .halign(.center)
        }
    }
}
