//
//  RealView.swift
//  Make chords (macOS)
//
//  Created by Nick Berendsen on 29/11/2020.
//

import SwiftUI

struct SongView: View {
    var song = Song()
    @AppStorage("showEditor") var showEditor: Bool = false
    
    var body: some View {
        let html = BuildHtml(song: song)
        HtmlView(html: html)
        .toolbar {
            ToolbarItem() {
                Button(action: {
                    withAnimation {
                        showEditor.toggle()
                }
                } ) {
                    HStack {
                        Image(systemName: "pencil").foregroundColor(.accentColor)
                        Text(showEditor ? "Hide editor" : "Edit song")
                        
                    }
                }
            }
        }
    }
}


