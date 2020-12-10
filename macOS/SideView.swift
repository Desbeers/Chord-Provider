//
//  SideView.swift
//  Make chords (macOS)
//
//  Created by Nick Berendsen on 01/12/2020.
//

import SwiftUI

struct SideView: View {
    @StateObject var song: Song
    
    @AppStorage("playMetronome") var playMetronome: Bool = false
    
    //@AppStorage("pathSongs") var pathSongs: String = GetDocumentsDirectory()
    var body: some View {
        VStack() {
 
            List() {
                //Caption
                Text("Song").font(.headline)
                
                if song.title != nil {
                    //Text(song.title!)
                    Label(song.title!, systemImage: "music.note.list").font(.headline)
                }
                if song.artist != nil {
                    //Text(song.artist!)
                    Label(song.artist!, systemImage: "music.mic").font(.subheadline)
                }
                Text("Details").font(.headline)
                HStack(){
                    if song.key != nil {
                        Label(song.key!, systemImage: "key")
                    }
                    if song.capo != nil {
                        Label(song.capo!, systemImage: "paperclip")
                    }
                    if song.tempo != nil {
                        Label(song.tempo!, systemImage: "metronome")
                    }
                }
                //if song.tempo != nil {
                    Text("Metronome").font(.headline)

                    MetronomeView().frame(minHeight: 200)
                //}
            }
        }
        .listStyle(SidebarListStyle())
    }
}


