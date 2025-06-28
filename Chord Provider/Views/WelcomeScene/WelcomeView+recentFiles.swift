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
                Section(header: Text("Your recent songs").font(.headline)) {
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
            }
            .scrollContentBackground(.hidden)
            .overlay(alignment: .top) {
                if appState.recentFiles.isEmpty {
                    ContentUnavailableView("You have no recent songs", systemImage: "clock")
                        .padding()
                }
            }
            if let randomSong {
                Divider()
                HStack {
                    Button {
                        self.randomSong = fileBrowser.songs.randomElement()
                    } label: {
                        Image(systemName: "shuffle")
                    }
                    .help("Another random song from your library")
                    Button {
                        Task {
                            if let url = randomSong.metadata.fileURL {
                                await openSong(url: url)
                            }
                        }
                    } label: {
                        Text(randomSong.metadata.title)
                    }
                    .help("A random song from your library")
                }
                .padding(.bottom, 6)
                .animation(.default, value: randomSong)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
