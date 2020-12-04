//
//  ContentView.swift
//  Shared
//
//  Created by Nick Berendsen on 28/11/2020.
//

import SwiftUI

struct MainView: View {
    @Binding var document: ChordProviderDocument
    @AppStorage("showEditor") var showEditor: Bool = false

    var body: some View {
        let song = ChordPro.parse(document.text)
        #if os(iOS)
        HStack () {
            if showEditor {
                EditorView(text: $document.text)
            }
            //VStack {
                //HeaderView(song: song)
                SongView(song: song)
            //}
        }
        #endif
        #if os(macOS)
        NavigationView {
            SideView(song: song).frame(minWidth: 200)
            HSplitView() {
                if showEditor {
                    EditorView(text: $document.text)
                        .font(.custom("HelveticaNeue", size: 14))
                        .frame(minWidth: 400)
                        .transition(.slide)
                }
                VStack(spacing: 0) {
                    //HeaderView(song: song).frame(height: 20)
                    SongView(song: song).frame(minWidth: 400)
                }.frame(minWidth: 400)
            }
        }
        #endif
    }
}
