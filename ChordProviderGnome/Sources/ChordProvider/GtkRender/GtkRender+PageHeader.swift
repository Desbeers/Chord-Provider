//
//  GtkRender+PageHeader.swift
//  ChordProvider
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
        init(appState: AppState) {
            self.appState = appState
            var subtitle: [String] = [appState.editor.song.metadata.subtitle ?? appState.editor.song.metadata.artist]
            if let album = appState.editor.song.metadata.album {
                subtitle.append(album)
            }
            if let year = appState.editor.song.metadata.year {
                subtitle.append(year)
            }
            self.subtitle = subtitle.joined(separator: " · ")
        }
        /// The state of the application
        let appState: AppState
        /// The subtitle
        let subtitle: String
        /// The body of the `View`
        var view: Body {
            VStack {
                Text(appState.editor.song.metadata.title)
                    .style(.title)
                Text(subtitle)
                    .style(.subtitle)
                    .padding(5, .top)
                /// Metadata
                HStack {
                    if let key = appState.editor.song.metadata.key {
                        metadata(name: "key", value: key.display)
                    }
                    if let capo = appState.editor.song.metadata.capo {
                        metadata(name: "capo", value: capo)
                    }
                    if let time = appState.editor.song.metadata.time {
                        metadata(name: "time", value: time)
                    }
                    Views.MetronomeToggle(metadata: appState.editor.song.metadata)
                }
                .style(.metadata)
                .halign(.center)
                .card()
                .padding(.top)
            }
            .padding(.top)
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
