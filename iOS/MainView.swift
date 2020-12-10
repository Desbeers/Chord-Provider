//
//  ContentView.swift
//  Shared
//
//  Created by Nick Berendsen on 28/11/2020.
//

import SwiftUI

struct MainView: View {
    @Binding var document: ChordProDocument
    @Binding var diagrams: [Diagram]
    @State var song = Song()
    @StateObject var metro = Metronome()
    @AppStorage("showEditor") var showEditor: Bool = false
    @AppStorage("showMetronome") var showMetronome: Bool = false
    @AppStorage("showChords") var showChords: Bool = true

    var body: some View {

        VStack() {
            if showMetronome {
                MetronomeView().frame(height: 100).background(Color.blue.opacity(0.3))
            }
            HeaderView(song: $song).background(Color.blue.opacity(0.3))
            HStack {
                SongView(song: $song)
                if showEditor {
                    EditorView(document: $document, diagrams: $diagrams, song: $song)
                }
            }
        }
        .onAppear(
            perform: {
                song = ChordPro.parse(document: document, diagrams: diagrams)
                print("MainView: ready")
            }
        )
        .toolbar {
            ToolbarItem() {
                Button(action: {
                    withAnimation {
                        showEditor.toggle()
                }
                } ) {
                    Image(systemName: showEditor ? "pencil.circle.fill" : "pencil.circle")

                }
            }
            ToolbarItem() {
                Button(action: {
                    withAnimation {
                        showMetronome.toggle()
                        self.metro.resetTimer()
                        metro.beep = false
                }
                } ) {
                    Image(systemName: showMetronome ? "metronome.fill" : "metronome")
                }
            }
            ToolbarItem() {
                Button(action: {
                    withAnimation {
                        showChords.toggle()
                        /// Rebuild the HTML view with or without chord diagrams
                        song.html = BuildSong(song: song, chords: showChords)
                }
                } ) {
                    Image(systemName: showChords ? "number.square.fill" : "number.square")

                }
            }
        }

    }
}
