//
//  HeaderView.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 02/12/2020.
//

import SwiftUI

struct HeaderView: View {
    //var name: String
    var song = Song()
    
    var body: some View {
  
            HStack(alignment: .center) {
            if song.title != nil {
                Text(song.title!).font(.headline)
            }
            if song.artist != nil {
                Text(song.artist!).font(.subheadline)
            }

                if song.key != nil {
                    Label(song.key!, systemImage: "key").padding(.leading)
                }
                if song.capo != nil {
                    Label(song.capo!, systemImage: "paperclip").padding(.leading)
                }
                if song.tempo != nil {
                    Label(song.tempo!, systemImage: "metronome").padding(.leading)
                }
            }.padding()

    }
}
