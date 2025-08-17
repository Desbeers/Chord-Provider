//
//  HeaderView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import ChordProviderCore

/// SwiftUI `View` for the header
struct HeaderView: View {
    /// The observable state of the application
    @Environment(AppStateModel.self) var appState
    /// The observable state of the scene
    @Environment(SceneStateModel.self) var sceneState
    /// The body of the `View`
    var body: some View {
        HStack(alignment: .center) {
            General(song: sceneState.song)
            Details(song: sceneState.song)
            MediaPlayerView.Buttons()
        }
        .padding(4)
        .frame(maxWidth: .infinity)
        .padding(.leading, 120)
        .overlay(alignment: .leading) {
            sceneState.chordsAsDiagramToggle
                .frame(maxWidth: 110, maxHeight: 30)
                .padding(.leading)
        }
        .padding(.trailing, 110)
        .overlay(alignment: .trailing) {
            sceneState.scaleSlider
                .frame(width: 100)
                .padding(.trailing)
        }
        .frame(minHeight: 45)
        .background(.ultraThinMaterial)
    }
}

extension HeaderView {

    /// SwiftUI `View` with general information
    struct General: View {
        /// The ``Song``
        let song: Song
        /// The metadata of the ``Song``
        private var metaData: [String] {
            var meta: [String] = []
            meta.append(song.metadata.artist)
            if let album = song.metadata.album {
                meta.append(album)
            }
            if let year = song.metadata.year {
                meta.append(year)
            }
            if let composers = song.metadata.composers {
                meta.append("\(composers.joined(separator: "/"))")
            }
            return meta
        }
        /// The body of the `View`
        var body: some View {
            VStack(alignment: .leading) {
                if !song.metadata.title.isEmpty {
                    Text(song.metadata.title)
                        .font(.headline)
                }
                Text(metaData.joined(separator: "∙"))
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            }
        }
    }

    /// SwiftUI `View` with details
    struct Details: View {
        /// The observable state of the application
        @Environment(AppStateModel.self) private var appState
        /// The ``Song``
        let song: Song
        /// The body of the `View`
        var body: some View {
            if let key = song.metadata.key {
                metadata(string: key.display, sfSymbol: .key)
            }
            if let capo = song.metadata.capo {
                metadata(string: capo, sfSymbol: .capo)
            }
            if let time = song.metadata.time {
                metadata(string: time, sfSymbol: .time)
            }
        }
        /// Show metadata with a SF symbol
        /// - Parameters:
        ///   - string: The metadata
        ///   - sfSymbol: The ``FontUtils/SFSymbol``
        /// - Returns: A `View`
        func metadata(string: String, sfSymbol: FontUtils.SFSymbol) -> some View {
            Label {
                Text(string)
            } icon: {
                Image(systemName: sfSymbol.rawValue)
                    .foregroundStyle(.secondary)
            }
            .padding(.leading, 4)
        }
    }
}
