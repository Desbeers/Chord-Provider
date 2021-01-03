//  MARK: - View: Header View for macOS and iOS

/// Song information and optional audo player for macOS

import SwiftUI

struct HeaderView: View {
    var song: Song
    #if os(iOS)
    @Environment(\.horizontalSizeClass) var sizeClass
    #endif

    var body: some View {
        #if os(macOS)
            HStack(alignment: .center) {
                Spacer()
                HeaderViewGeneral(song: song)
                HeaderViewDetails(song: song)
                if song.musicpath != nil {
                    AudioPlayer(song: song)
                }
                Spacer()
            }
            .padding(4)
        #endif
        #if os(iOS)
        if sizeClass == .compact {
            VStack {
                HStack {
                    Spacer()
                    HeaderViewGeneral(song: song).padding(4)
                    Spacer()
                }
                HeaderViewDetails(song: song)
            }
            .padding(4)
        } else {
            HStack(alignment: .center) {
                Spacer()
                HeaderViewGeneral(song: song)
                HeaderViewDetails(song: song)
                Spacer()
            }
            .padding(4)
        }
        #endif
    }
}

struct HeaderViewGeneral: View {
    var song: Song

    var body: some View {
        HStack(alignment: .center) {
            if song.artist != nil {
                Text(song.artist!).font(.headline)
            }
            if song.title != nil {
                Text(song.title!)
            }
        }
    }
}

struct HeaderViewDetails: View {
    var song: Song

    var body: some View {
        HStack(alignment: .center) {
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
        }
    }
}
