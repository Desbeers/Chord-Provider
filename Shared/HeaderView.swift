//  MARK: - View: Header View for macOS and iOS

/// Song information and optional audo player for macOS

import SwiftUI

struct HeaderView: View {
    var song: Song

    var body: some View {
            HStack(alignment: .center) {
                Spacer()
                if song.artist != nil {
                    Text(song.artist!).font(.headline)
                }
                if song.title != nil {
                    Text(song.title!)
                }
                if song.key != nil {
                    Label(song.key!, systemImage: "key").padding(.leading)
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
                #if os(macOS)
                if song.musicpath != nil {
                    AudioPlayer(song: song)
                }
                #endif
                Spacer()
            }
            .padding(4)
    }
}
