//
//  WelcomeView+recentFiles.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import OSLog

extension WelcomeView {

    /// The body of the `View`
    var recentFiles: some View {
        VStack {
            List {
                ForEach(appState.recentFiles, id: \.self) { url in
                    Button(
                        action: {
                            Task {
                                await openSong(url: url)
                            }
                        },
                        label: {
                            Label(url.deletingPathExtension().lastPathComponent, systemImage: "document.badge.clock")
                        }
                    )
                }
                .listRowSeparator(.hidden)
            }
            .scrollContentBackground(.hidden)
            .overlay {
                if appState.recentFiles.isEmpty {
                    Text("You have no recent songs")
                }
            }
            if let song = fileBrowser.songList.randomElement() {
                Divider()
                Button {
                    Task {
                        await openSong(url: song.fileURL)
                    }
                } label: {
                    Label(song.title, systemImage: "shuffle")
                }
                .help("A random song from your library")
                .padding(.bottom, 6)
                .labelStyle(.titleAndIcon)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
