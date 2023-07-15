//
//  HeaderView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for the header
struct HeaderView: View {
    /// The ``Song``
    let song: Song
    /// The optional file location
    let file: URL?
    /// Current scaling of the `View`
    @SceneStorage("scale")
    var scale: Double = 1.2
    /// The body of the `View`
    var body: some View {
#if os(macOS)
        HStack(alignment: .center) {
            General(song: song)
            Details(song: song)
            if let musicURL = getMusicURL() {
                AudioPlayerView(musicURL: musicURL)
            }
        }
        .frame(maxWidth: .infinity)
        .overlay(alignment: .trailing) {
            Slider(value: $scale, in: 0.8...2.0) {
                Label("Zoom", systemImage: "magnifyingglass")
            }
            .frame(width: 140)
            .padding(.trailing)
        }
        .padding(4)
#endif
#if os(iOS)
        General(song: song)
        Details(song: song)
#endif
    }

    /// Get the URL for the music file
    /// - Parameter musicPath: Te path of the file
    /// - Returns: A full URL to the file, if found
    func getMusicURL() -> URL? {
        guard let file, let path = song.musicPath else {
            return nil
        }
        var musicURL = file.deletingLastPathComponent()
        musicURL.appendPathComponent(path)
        return musicURL
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
            HStack(alignment: .center) {
                if let key = song.key {
                    Label(key.display.symbol, systemImage: "key").padding(.leading)
                }
                if let capo = song.capo {
                    Label(capo, systemImage: "paperclip").padding(.leading)
                }
                if let tempo = song.tempo {
                    Label(tempo, systemImage: "metronome").padding(.leading)
                }
                if let time = song.time {
                    Label(time, systemImage: "repeat").padding(.leading)
                }
            }
        }
    }
}
