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
        /// - Parameter appState: The state of the application
        init(appState: Binding<AppState>) {
            self._appState = appState
            let metadata = appState.editor.song.metadata.wrappedValue
            var subtitle: [String] = [metadata.subtitle ?? metadata.artist]
            if let album = metadata.album {
                subtitle.append(album)
            }
            if let year = metadata.year {
                subtitle.append(year)
            }
            self.subtitle = subtitle.joined(separator: " · ")
            self.metadata = metadata
        }
        /// The state of the application
        @Binding var appState: AppState
        /// The subtitle
        let subtitle: String
        /// The metadata
        let metadata: Song.Metadata
        /// Bool to show more metadata
        @State private var showMoreMetadata: Bool = false
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
                    if let key = metadata.key {
                        metadata(name: "key", value: key.display)
                    }
                    if let capo = metadata.capo {
                        metadata(name: "capo", value: capo)
                    }
                    if let time = metadata.time {
                        metadata(name: "time", value: time)
                    }
                    Views.MetronomeToggle(appState: $appState)
                    if let additionalMetadata = additionalMetadata() {
                        Button("More…") {
                            showMoreMetadata.toggle()
                        }
                        .flat()
                        .popover(visible: $showMoreMetadata) {
                            ForEach(additionalMetadata) { item in
                                Text(item.content)
                                    .useMarkup()
                            }
                        }
                    }
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

        private func additionalMetadata() -> [String.ElementWrapper]? {
            var result = [String.ElementWrapper]()
            if let duration = metadata.formatDuration {
                appendMetadata([duration.toElementWrapper], label: "Duration", result: &result)
            }
            if let arrangers = metadata.arrangers {
                appendMetadata(arrangers, label: "Arranger", result: &result)
            }
            if let lyricists = metadata.lyricists {
                appendMetadata(lyricists, label: "Lyricist", result: &result)
            }
            if let composers = metadata.composers {
                appendMetadata(composers, label: "Composer", result: &result)
            }
            if let copyright = metadata.copyright {
                appendMetadata(["© \(copyright)".toElementWrapper], label: "Copyright", result: &result)
            }
            return result.isEmpty ? nil : result
        }

        private func appendMetadata(_ metadata: [String.ElementWrapper], label: String, result: inout [String.ElementWrapper]) {
            result.append(.init(content: "<b>\(label)\(metadata.count > 1 ? "s" : "")</b>"))
            for item in metadata {
                result.append(.init(content: "\(item.content)"))
            }
        }
    }
}
