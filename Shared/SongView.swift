//
//  RealView.swift
//  Make chords (macOS)
//
//  Created by Nick Berendsen on 29/11/2020.
//

import SwiftUI

struct SongView: View {
    @Binding var song: Song
    
    @StateObject var metro = Metronome()
    @AppStorage("showEditor") var showEditor: Bool = false
    @AppStorage("showMetronome") var showMetronome: Bool = false
    @AppStorage("showChords") var showChords: Bool = true
    
    var body: some View {
        VStack {
            HtmlView(html: (song.html ?? ""))
        }
        
    }
}


