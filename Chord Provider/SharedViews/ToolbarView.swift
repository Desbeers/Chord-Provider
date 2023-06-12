//
//  ToolbarView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

struct ToolbarView: View {
    /// The song
    @Binding var song: Song
    /// Bool to show the editor or not
    @SceneStorage("showEditor") var showEditor: Bool = false
    /// Bool to show the chords or not
    @AppStorage("showChords") var showChords: Bool = true
    /// The body of the `View`
    var body: some View {
        Button(action: {
            song.transpose -= 1
        }, label: {
            Label("♭", systemImage: "arrow.down")
                .font(.title2)
                .foregroundColor(song.transpose < 0 ? .accentColor : .primary)
        })
        .labelStyle(.titleAndIcon)
        Button(action: {
            song.transpose += 1
        }, label: {
            Label("♯", systemImage: "arrow.up")
                .font(.title2)
                .foregroundColor(song.transpose > 0 ? .accentColor : .primary)
        })
        .labelStyle(.titleAndIcon)
        Button {
            withAnimation {
                showChords.toggle()
            }
        } label: {
            Label(showChords ? "Hide chords" : "Show chords", systemImage: showChords ? "number.square.fill" : "number.square")
                .frame(minWidth: 110, alignment: .leading)
        }
        .labelStyle(.titleAndIcon)
        .disabled(showEditor)
        Button {
            withAnimation {
                showEditor.toggle()
            }
        } label: {
            Label(showEditor ? "Hide editor" : "Edit song", systemImage: showEditor ? "pencil.circle.fill" : "pencil.circle")
                .frame(minWidth: 110, alignment: .leading)
        }
        .labelStyle(.titleAndIcon)
    }
}
