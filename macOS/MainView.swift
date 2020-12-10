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
    @AppStorage("showEditor") var showEditor: Bool = false
    @AppStorage("showMetronome") var showMetronome: Bool = false
    @AppStorage("showChords") var showChords: Bool = true

    var body: some View {

        NavigationView {
            SideView(song: $song).frame(minWidth: 200)
            HSplitView() {
                HStack(alignment: .top,spacing: 0) {
                    VStack() {
                        HeaderView(song: $song).background(Color.accentColor.opacity(0.3)).padding(.bottom)
                        SongView(song: $song).frame(minWidth: 400)
                    }
                }.frame(minWidth: 400)
                if showEditor {
                    EditorView(document: $document, diagrams: $diagrams, song: $song)
                        .font(.custom("HelveticaNeue", size: 14))
                        .frame(minWidth: 400)
                        .transition(.slide)
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
                        showChords.toggle()
                        /// Rebuild the HTML view with or without chord diagrams
                        song.html = BuildSong(song: song, chords: showChords)
                }
                } ) {
                    HStack {
                        Image(systemName: showChords ? "number.square.fill" : "number.square").foregroundColor(.accentColor)
                        Text(showChords ? "Hide chords" : "Show chords")
                        
                    }
                }
            }
            ToolbarItem() {
                Button(action: {
                    withAnimation {
                        showEditor.toggle()
                        
                }
                } ) {
                    HStack {
                        Image(systemName: showEditor ? "pencil.circle.fill" : "pencil.circle").foregroundColor(.accentColor)
                        Text(showEditor ? "Hide editor" : "Edit song")
                        
                    }
                }
            }
            ToolbarItem(placement: .navigation) {
                Button(action: {
                    NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
                } ) {
                    Image(systemName: "sidebar.left").foregroundColor(.accentColor)
                }
            }
        }
    }
}
