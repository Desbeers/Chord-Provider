//
//  GtkRender+PageHeader.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension GtkRender {

    /// The `View` for the song header
    struct PageHeader: View {
        /// The whole song
        let song: Song
        /// The settings of the application
        let settings: AppSettings
        /// The body of the `View`
        var view: Body {
            VStack {
                /// Show optional tags
                if let tags = song.metadata.tags {
                    Overlay()
                        .overlay {
                            HStack {
                                ForEach(tags.map { Markup.StringItem(string: $0) }, horizontal: true) { tag in
                                    Text(tag.string)
                                        .style(.tagLabel)
                                        .padding(5, .leading)
                                }
                            }
                            .hexpand()
                            .halign(.end)
                            .padding(10, .trailing)
                        }
                }
                Text(song.metadata.title)
                    .style(.title)
                Text(song.metadata.subtitle ?? song.metadata.artist)
                    .style(.subtitle)
                    .padding(5, .top)
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
            }
            .padding(10, .top)
        }
        /// Show metadata with an icon
        /// - Parameters:
        ///   - name: Name of the icon
        ///   - value: The value of the metadata
        /// - Returns: A View
        @ViewBuilder private func metadata(name: String, value: String) -> Body {
            HStack(spacing: 5) {
                Widgets.BundleImage(name: name)
                    .pixelSize(16)
                    .valign(.baselineCenter)
                Text(value)
            }
            .padding()
        }
    }
}
