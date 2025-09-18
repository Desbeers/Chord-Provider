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
    init(render: String, id: UUID, settings: AppSettings) {
        self.settings = settings
        LogUtils.shared.clearLog()
        let song = Song(id: id, content: render)
        let result = ChordProParser.parse(
            song: song,
            settings: settings.core
        )
        self.song = result
    }
    let song: Song
    let settings: AppSettings

    var view: Body {
        HStack {
            ScrollView {
                VStack {
                    Text(song.metadata.title, font: .title, zoom: settings.app.zoom)
                        .useMarkup()
                    Text(song.metadata.subtitle ?? "", font: .subtitle, zoom: settings.app.zoom)
                        .useMarkup()
                    GtkRender.SectionsView(song: song, settings: settings)
                        .halign(.center)
                }
                .padding(20)
                .hexpand()
            }
            Separator()
            ChordsView(song: song, settings: settings)
                .frame(minWidth: 100)
        }
    }
}
