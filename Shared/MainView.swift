//
//  ContentView.swift
//  Shared
//
//  Created by Nick Berendsen on 28/11/2020.
//

import SwiftUI

struct MainView: View {
    @Binding var document: ChordProDocument
    @State var chordpro: Song
    @AppStorage("showEditor") var showEditor: Bool = false
    @AppStorage("showMetronome") var showMetronome: Bool = false

    var body: some View {
        //var song = ChordPro.parse(document)
        #if os(iOS)
        VStack() {
            if showMetronome {
                MetronomeView().frame(height: 100).background(Color.blue.opacity(0.3))
            }
            HeaderView(song: chordpro).background(Color.blue.opacity(0.3))
            HStack {
                SongView(song: chordpro)
                if showEditor {
                    EditorView(text: $document.text)
                }
            }
        }
        #endif
        #if os(macOS)
        NavigationView {
            SideView(song: chordpro).frame(minWidth: 200)
            HSplitView() {
                HStack(alignment: .top,spacing: 0) {
                    VStack() {
                        HeaderView(song: chordpro).background(Color.accentColor.opacity(0.3)).padding(.bottom)
                        SongView(song: chordpro).frame(minWidth: 400)
                    }
                }.frame(minWidth: 400)
                if showEditor {
                    EditorView(text: $document.text)
                        .font(.custom("HelveticaNeue", size: 14))
                        .frame(minWidth: 400)
                        .transition(.slide)
                }
            }
        }
        #endif
    }
}
