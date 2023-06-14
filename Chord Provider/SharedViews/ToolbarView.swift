//
//  ToolbarView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

/// Swiftui `View` for the toolbar
struct ToolbarView: View {
    /// The ``song``
    @Binding var song: Song
    /// Bool to show the editor or not
    @SceneStorage("showEditor") var showEditor: Bool = false
    /// Bool to show the chords or not
    @AppStorage("showChords") var showChords: Bool = true
    /// The body of the `View`
    var body: some View {
        Group {
            Button(action: {
                song.transpose -= 1
            }, label: {
                Label("♭", systemImage: "arrow.down")
                    .foregroundColor(song.transpose < 0 ? .primary : .accentColor)
            })
            Button(action: {
                song.transpose += 1
            }, label: {
                Label("♯", systemImage: "arrow.up")
                    .foregroundColor(song.transpose > 0 ? .primary : .accentColor)
            })
            Button {
                showChords.toggle()
            } label: {
                Label(showChords ? "Hide chords" : "Show chords", systemImage: showChords ? "number.square.fill" : "number.square")
                    .frame(minWidth: 110, alignment: .leading)
            }
            Button {
                showEditor.toggle()
            } label: {
                Label(showEditor ? "Hide editor" : "Edit song", systemImage: showEditor ? "pencil.circle.fill" : "pencil.circle")
                    .frame(minWidth: 110, alignment: .leading)
            }
        }
        .labelStyle(.titleAndIcon)
    }
}
