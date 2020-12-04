//
//  SideView.swift
//  Make chords (macOS)
//
//  Created by Nick Berendsen on 01/12/2020.
//

import SwiftUI

struct SideView: View {
    var song = Song()
    
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
                    //Text("Metronome").font(.headline)
                    //Button(action: {
                    //    playMetronome.toggle()
                    //} ) {
                    //    Text(playMetronome ? "Start metronome" : "Stop metronome")
                    //}
                    
                //}
            }
        }
        //.frame(minWidth: 240)
        .listStyle(SidebarListStyle())
        .toolbar {
            ToolbarItem() {
                Button(action: {
                    NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
                } ) {
                    Image(systemName: "sidebar.left").foregroundColor(.accentColor)
                }
            }
        }
    }
}

struct SideView_Previews: PreviewProvider {
    static var previews: some View {
        SideView()
    }
}


