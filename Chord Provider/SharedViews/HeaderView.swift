//
//  HeaderView.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` with song information and optional audio player for macOS
struct HeaderView: View {
    /// The ``Song``
    var song: Song
    /// Current scaling of the `View`
    @SceneStorage("scale") var scale: Double = 1.2
    /// Previous scaling of the `View`
    @SceneStorage("previousScale") var previousScale: Double = 1.2
    /// The body of the `View`
    var body: some View {
#if os(macOS)
        HStack(alignment: .center) {
            Spacer()
            General(song: song)
            Details(song: song)
            if let musicURL = song.musicURL {
                AudioPlayerView(musicURL: musicURL)
            }
            Spacer()
        }
        .overlay(alignment: .trailing) {
            Stepper(label: {
                Label("Zoom", systemImage: "magnifyingglass")
            }, onIncrement: {
                withAnimation {
                    scale += 0.1
                    previousScale += 0.1
                }
            }, onDecrement: {
                withAnimation {
                    scale -= 0.1
                    previousScale -= 0.1
                }
            })
        }
        .padding(4)
#endif
#if os(iOS)
        Text("Not in use")
#endif
    }
}

extension HeaderView {

    /// SwiftUI `View` with general information
    struct General: View {
        /// The ``Song``
        let song: Song
        /// The metadata of the ``Song``
        private let metaData: [String]
        /// Init the `View` with the metadata
        init(song: Song, metaData: [String] = []) {
            self.song = song
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
            self.metaData = meta
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
            HStack(alignment: .center) {
                if let key = song.key {
                    Label(key.display.symbol, systemImage: "key").padding(.leading)
                }
                if song.capo != nil {
                    Label(song.capo!, systemImage: "paperclip").padding(.leading)
                }
                if song.tempo != nil {
                    Label(song.tempo!, systemImage: "metronome").padding(.leading)
                }
                if song.time != nil {
                    Label(song.time!, systemImage: "repeat").padding(.leading)
                }
            }
            .font(.none)
        }
    }
}
