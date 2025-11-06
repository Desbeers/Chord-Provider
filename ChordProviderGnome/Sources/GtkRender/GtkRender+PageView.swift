//
//  GtkRender+PageView.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension GtkRender {

    /// The `View` for a whole song
    struct PageView: View {

        let song: Song
        let settings: AppSettings

        var view: Body {
            VStack {
                /// Show optional tags
                if let tags = song.metadata.tags {
                    Overlay()
                        .overlay {
                            HStack {
                                ForEach(tags.map { Markup.StringItem(string: $0) }, horizontal: true) { tag in
                                    Text(tag.string)
                                        .style(Markup.Class.tagLabel.description)
                                        .padding(5, .leading)
                                }
                            }
                            .hexpand()
                            .halign(.end)
                        }
                }
                Text(song.metadata.title)
                    .style(.title)
                Text(song.metadata.subtitle ?? song.metadata.artist)
                    .style(.subtitle)
                GtkRender.SectionsView(song: song, settings: settings)
                    .halign(.center)
            }
            .padding(20)
            .hexpand()
        }
    }
}
