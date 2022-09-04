//
//  HeaderView.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// The View with song information and optional audio player for macOS
struct HeaderView: View {
    var song: Song
    #if os(iOS)
    @Environment(\.horizontalSizeClass) var sizeClass
    @AppStorage("showEditor") var showEditor: Bool = false
    @AppStorage("showChords") var showChords: Bool = true
    #endif

    var body: some View {
        #if os(macOS)
            HStack(alignment: .center) {
                Spacer()
                General(song: song)
                Details(song: song)
                if song.musicpath != nil {
                    AudioPlayerView(song: song)
                }
                Spacer()
            }
            .padding(4)
        #endif
        #if os(iOS)
        HStack(alignment: .center) {
            Button(action: {
                goBack()
            }, label: {
                Image(systemName: "chevron.backward")
            })
            Spacer()
            General(song: song)
            Details(song: song)
            Spacer()
            Button {
                withAnimation {
                    showChords.toggle()
                }
            } label: {
                Image(systemName: showChords ? "number.square.fill" : "number.square")
            }
            Button {
                withAnimation {
                    showEditor.toggle()
                }
            } label: {
                Image(systemName: showEditor ? "pencil.circle.fill" : "pencil.circle")
            }
        }
        .font(.title)
        .padding()
        #endif
    }
}

extension HeaderView {
    
    /// The View with general information
    struct General: View {
        let song: Song
        var body: some View {
            VStack(alignment: .leading) {
                if song.artist != nil {
                    Text(song.artist!)
                        .font(.headline)
                }
                if song.title != nil {
                    Text(song.title!)
                        .font(.subheadline)
                }
            }
        }
    }
    
    /// The View with details
    struct Details: View {
        let song: Song
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
            .font(.none)
        }
    }
}
