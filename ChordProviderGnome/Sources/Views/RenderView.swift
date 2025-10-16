//
//  RenderView.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore
import ChordProviderHTML

/// The `View` for the rendered song
struct RenderView: View {

    let song: Song
    let settings: AppSettings

    var view: Body {
        HStack {
            ScrollView {
                VStack {
                    Text(song.metadata.title, font: .title, zoom: settings.app.zoom)
                        .useMarkup()
                    Text(song.metadata.subtitle ?? song.metadata.artist, font: .subtitle, zoom: settings.app.zoom)
                        .useMarkup()
                    GtkRender.SectionsView(song: song, settings: settings)
                        .halign(.center)
                }
                .padding(20)
                .hexpand()
            }
            Separator()
            if !song.chords.isEmpty {
                ChordsView(song: song, settings: settings)
                    .frame(minWidth: 100)
                    .transition(.coverLeftRight)
            }

        }
    }
}
