// MARK: - View: Header View for macOS and iOS

/// Song information and optional audo player for macOS

import SwiftUI

struct ViewHeader: View {
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
                ViewHeaderGeneral(song: song)
                ViewHeaderDetails(song: song)
                if song.musicpath != nil {
                    ViewAudioPlayer(song: song)
                }
                Spacer()
            }
            .padding(4)
        #endif
        #if os(iOS)
        /// No need to show the artist and song on iOS because thats already shown because its a document scene
        HStack(alignment: .center) {
            Button(action: {
                goBack()
            }, label: {
                Image(systemName: "chevron.backward")
            })
            Spacer()
            ViewHeaderGeneral(song: song)
            ViewHeaderDetails(song: song)
            Spacer()
            Button {
                withAnimation {
                    showChords.toggle()
                }
            }
            label: {
                HStack {
                    Image(systemName: showChords ? "number.square.fill" : "number.square")
                }
            }
            Button {
                withAnimation {
                    showEditor.toggle()
                }
            }
            label: {
                Image(systemName: showEditor ? "pencil.circle.fill" : "pencil.circle")
            }
        }
        .font(.title)
        .padding()
        #endif
    }
}

struct ViewHeaderGeneral: View {
    var song: Song

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

struct ViewHeaderDetails: View {
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
        .font(.none)
    }
}
