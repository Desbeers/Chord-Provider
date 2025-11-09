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
                            .padding()
                        }
                }
                Text(song.metadata.title)
                    .style(.title)
                Text(song.metadata.subtitle ?? song.metadata.artist)
                    .style(.subtitle)
                /// Metadata
                HStack {
                    if let key = song.metadata.key {
                        metadata(name: "key", value: key.display)
                    }
                    if let capo = song.metadata.capo {
                        metadata(name: "capo", value: capo)
                    }
                    if let time = song.metadata.time {
                        metadata(name: "time", value: time)
                    }
                    if let tempo = song.metadata.tempo {
                        metadata(name: "tempo", value: tempo)
                    }
                }
                .style(.metadata)
                .halign(.center)
                .card()
                .padding(10, .top)
                ScrollView {
                    GtkRender.SectionsView(song: song, settings: settings)
                        .halign(.center)
                        .padding(20)
                }
                .vexpand()
            }
            //.padding(20)
            .hexpand()
        }
        
        /// Show metadata with an icon
        /// - Parameters:
        ///   - name: Name of the icon
        ///   - value: The value of the metadata
        /// - Returns: A View
        private func metadata(name: String, value: String) -> AnyView {
            HStack(spacing: 5) {
                BundleImage(name: name)
                    .pixelSize(16)
                    .valign(.baselineCenter)
                Text(value)
            }
            .padding()
        }
    }
}
