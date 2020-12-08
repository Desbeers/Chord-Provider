//
//  ContentView.swift
//  Shared
//
//  Created by Nick Berendsen on 28/11/2020.
//

import SwiftUI

struct MainView: View {
    @Binding var document: ChordProDocument
    @AppStorage("showEditor") var showEditor: Bool = false
    @AppStorage("showMetronome") var showMetronome: Bool = false

    var body: some View {
        let song = ChordPro.parse(document.text)
        #if os(iOS)
        VStack() {
            if showMetronome {
                MetronomeView().frame(height: 100).background(Color.blue.opacity(0.3))
            }
            HeaderView(song: song).background(Color.blue.opacity(0.3))
            HStack {
                SongView(song: song)
                if showEditor {
                    EditorView(text: $document.text)
                }
            }
        }
        #endif
        #if os(macOS)
        NavigationView {
            SideView(song: song).frame(minWidth: 200)
            HSplitView() {
                HStack(alignment: .top,spacing: 0) {
                    VStack() {
                        HeaderView(song: song).background(Color.accentColor.opacity(0.3)).padding(.bottom)
                        SongView(song: song).frame(minWidth: 400)
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
