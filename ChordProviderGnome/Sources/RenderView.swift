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

struct RenderView: View {
    init(render: String, id: UUID) {
        let song = Song(id: id, content: render)
        let result = ChordProParser.parse(
            song: song,
            instrument: .guitar,
            prefixes: [],
            getOnlyMetadata: false
        )
        self.song = result
    }
    let song: Song

    var view: Body {
        ScrollView {
            VStack {
                Label("<span size='xx-large'>\(song.metadata.title)</span>")
                    .useMarkup()
                    .heading()
                Text("<span size='x-large'>\(song.metadata.subtitle ?? "")</span>")
                    .useMarkup()
                GtkRender.SectionsView(song: song)
                    .halign(.center)
            }
            .padding(20)
        }
    }
}
