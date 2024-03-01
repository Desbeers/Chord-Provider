//
//  HeaderView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for the header
struct HeaderView: View {
    /// The app state
    @Environment(AppState.self) var appState
    /// The scene state
    @Environment(SceneState.self) var sceneState
    /// The body of the `View`
    var body: some View {
        HStack(alignment: .center) {
            General(song: sceneState.song)
            Details(song: sceneState.song)
            if let tempo = sceneState.song.tempo, let bpm = Float(tempo) {
                MetronomeView(time: sceneState.song.time ?? "4/4", bpm: bpm)
                    .padding(.leading)
            }
            sceneState.audioPlayerButtons
        }
        .padding(4)
        .frame(maxWidth: .infinity)
        .padding(.leading, 120)
        .overlay(alignment: .leading) {
            appState.chordsAsDiagramToggle
                .frame(maxWidth: 110, maxHeight: 30)
                .padding(.leading)
        }
#if os(macOS)
        .padding(.trailing, 110)
        .overlay(alignment: .trailing) {
            sceneState.scaleSlider
                .frame(width: 100)
                .padding(.trailing)
        }
#endif
        .frame(minHeight: 45)
        .background(Color.telecasterPlate.opacity(0.8))
        .foregroundStyle(.white)
        .buttonStyle(.bordered)
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
            if let artist = song.artist {
                meta.append(artist)
            }
            if let album = song.album {
                meta.append(album)
            }
            if let year = song.year {
                meta.append(year)
            }
            return meta
        }
        /// The body of the `View`
        var body: some View {
            VStack(alignment: .leading) {
                if let title = song.title {
                    Text(title)
                        .font(.headline)
                }
                Text(metaData.joined(separator: "∙"))
                    .font(.subheadline)
            }
        }
    }

    /// SwiftUI `View` with details
    struct Details: View {
        /// The ``Song``
        let song: Song
        /// The body of the `View`
        var body: some View {
            if let key = song.key {
                Label("\(key.displayName(options: .init()))", systemImage: "key").padding(.leading)
            }
            if let capo = song.capo {
                Label(capo, systemImage: "paperclip").padding(.leading)
            }
            if let time = song.time {
                Label(time, systemImage: "timer").padding(.leading)
            }
        }
    }
}
