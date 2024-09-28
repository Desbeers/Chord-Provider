//
//  HeaderView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

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
            if let tempo = sceneState.song.metaData.tempo, let bpm = Float(tempo) {
                MetronomeView(time: sceneState.song.metaData.time ?? "4/4", bpm: bpm)
                    .padding(.leading)
            }
            sceneState.audioPlayerButtons
        }
        .padding(4)
        .frame(maxWidth: .infinity)
        .padding(.leading, 120)
        .overlay(alignment: .leading) {
            sceneState.chordsAsDiagramToggle
                .frame(maxWidth: 110, maxHeight: 30)
                .padding(.leading)
                .disabled(sceneState.preview.active)
        }
        .padding(.trailing, 110)
        .overlay(alignment: .trailing) {
            sceneState.scaleSlider
                .frame(width: 100)
                .padding(.trailing)
                .disabled(sceneState.preview.active)
        }
        .frame(minHeight: 45)
        .background(Color.accentColor.saturation(0.6))
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
            meta.append(song.metaData.artist)
            if let album = song.metaData.album {
                meta.append(album)
            }
            if let year = song.metaData.year {
                meta.append(year)
            }
            return meta
        }
        /// The body of the `View`
        var body: some View {
            VStack(alignment: .leading) {
                if !song.metaData.title.isEmpty {
                    Text(song.metaData.title)
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
            if let key = song.metaData.key {
                Label("\(key.displayName(options: .init()))", systemImage: "key").padding(.leading)
            }
            if let capo = song.metaData.capo {
                Label(capo, systemImage: "paperclip").padding(.leading)
            }
            if let time = song.metaData.time {
                Label(time, systemImage: "timer").padding(.leading)
            }
        }
    }
}
