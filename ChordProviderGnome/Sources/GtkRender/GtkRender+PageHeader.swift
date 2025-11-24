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
        /// Init the `View`
        init(song: Song, settings: AppSettings) {
            self.song = song
            self.settings = settings
            var subtitle: [String] = [song.metadata.subtitle ?? song.metadata.artist]
            if let album = song.metadata.album {
                subtitle.append(album)
            }
            if let year = song.metadata.year {
                subtitle.append(year)
            }
            self.subtitle = subtitle.joined(separator: " · ")
        }
        /// The whole song
        let song: Song
        /// The settings of the application
        let settings: AppSettings
        /// The subtitle
        let subtitle: String
        /// The body of the `View`
        var view: Body {
            VStack {
                Text(song.metadata.title)
                    .style(.title)
                Text(subtitle)
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
                    .style(.svgIcon)
                Text(value)
            }
            .padding()
        }
    }
}
