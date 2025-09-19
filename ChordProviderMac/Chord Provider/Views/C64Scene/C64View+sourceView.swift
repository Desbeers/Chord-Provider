//
//  C64View+sourceView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension C64View {

    /// The source view
    var sourceView: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                Text(bootText)
                if let song = appState.song {
                    Text("load \"\(song.metadata.title)\",8,1")
                    Text(" ")
                    Text("searching for \(song.metadata.title)")
                    Text("loading")
                    Text("ready.")
                    Text(" ")
                    Text("list")
                    Text(" ")
                    ForEach(output) { line in
                        Text(line.code)
                    }
                    ForEach((0..<runCounter), id: \.self) { _ in
                        Text("ready.")
                        Text("run")
                    }
                    if !run {
                        Text("ready.")
                    }
                } else {
                    Text("?song not found  error")
                    Text("ready.")
                }
                Image(systemName: "square.fill")
                    .symbolEffect(.pulse, options: .repeat(.continuous))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(C64Color.blue.swiftColor)
    }
}
