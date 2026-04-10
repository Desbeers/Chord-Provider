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
            let metadata = GtkRender.PageHeader.collectMetadata(appState.editor.song.metadata.wrappedValue)
            self.metadata = Array(metadata.prefix(4))
            self.additionalMetadata = Array(metadata.dropFirst(4))
        }
        /// The state of the application
        @Binding var appState: AppState
        /// The metadata
        let metadata: [MetaData]
        /// The additional metadata
        let additionalMetadata: [MetaData]
        /// Bool to show more metadata
        @State private var showMoreMetadata: Bool = false
        /// The body of the `View`
        var view: Body {
            /// Metadata
            HStack {
                ForEach(metadata, horizontal: true) { item in
                    metadata(item)
                }
                Views.MetronomeToggle(appState: $appState)
                    .tooltip("Play the metronome")
                if !additionalMetadata.isEmpty {
                    Toggle("More…", isOn: $showMoreMetadata)
                        .style(.pageHeaderToggle)
                        .flat()
                        .tooltip("Show more information about the song")
                        .popover(visible: $showMoreMetadata) {
                            ForEach(additionalMetadata) { item in
                                VStack {
                                    Text(item.label)
                                    .useMarkup()
                                    Text(item.value)
                                }
                                .padding(4)
                            }
                        }
                }
            }
            .style(.metadata)
            .halign(.center)
            .card()
        }

        /// Show metadata with an icon
        /// - Parameters:
        ///   - name: Name of the icon
        ///   - value: The value of the metadata
        /// - Returns: A View
        private func metadata( _ metadata: MetaData) -> AnyView {
            HStack(spacing: 5) {
                Widgets.BundleImage(icon: metadata.icon)
                    .pixelSize(16)
                    .valign(.center)
                    .style(.svgIcon)
                Text(metadata.value)
            }
            .padding()
            .tooltip(metadata.label)
        }

        /// Collect metadata
        /// - Returns: An array of metadata
        private static func collectMetadata(_ metadata: Song.Metadata) -> [MetaData] {
            var result = [MetaData]()
            if let key = metadata.key {
                result.append(
                    MetaData(
                        icon: .key,
                        label: "Key",
                        value: key.display
                    )
                )
            }
            if let capo = metadata.capo {
                result.append(
                    MetaData(
                        icon: .capo,
                        label: "Capo",
                        value: capo
                    )
                )
            }
            if let time = metadata.time {
                result.append(
                    MetaData(
                        icon: .time,
                        label: "Time",
                        value: time
                    )
                )
            }
            if let duration = metadata.formatDuration {
                result.append(
                    MetaData(
                        icon: .duration,
                        label: "Duration",
                        value: duration
                    )
                )
            }
            if let year = metadata.year {
                result.append(
                    MetaData(
                        icon: .year,
                        label: "Year",
                        value: year
                    )
                )
            }
            if let copyright = metadata.copyright {
                result.append(
                    MetaData(
                        icon: .copyright,
                        label: "Copyright",
                        value: copyright
                    )
                )
            }
            if let arrangers = metadata.arrangers {
                result.append(
                    MetaData(
                        icon: .person,
                        label: "Arranger",
                        value: arrangers.map(\.content).joined(separator: "\n")
                    )
                )
            }
            if let lyricists = metadata.lyricists {
                result.append(
                    MetaData(
                        icon: .person,
                        label: "Lyricist",
                        value: lyricists.map(\.content).joined(separator: "\n")
                    )
                )
            }
            if let composers = metadata.composers {
                result.append(
                    MetaData(
                        icon: .person,
                        label: "Composer",
                        value: composers.map(\.content).joined(separator: "\n")
                    )
                )
            }
            return result
        }

        /// Structure of a metadata item
        struct MetaData: Identifiable {
            /// Identifiable protocol
            let id = UUID()
            /// The icon to use
            /// - Note: Used in the main part of the `View`
            var icon: ImageUtils.Icon
            /// The label
            /// - Note: Used in the *more* part of the `View`
            var label: String
            /// The value
            var value: String
        }
    }
}
