//
//  WelcomeView+RecentFiles.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import OSLog

extension WelcomeView {

    /// SwiftUI `View` for the recent files
    @MainActor struct RecentFiles: View {
        /// The observable state of the application
        @State private var appState = AppStateModel.shared
        /// The observable ``FileBrowser`` class
        @State private var fileBrowser = FileBrowserModel.shared
        /// The AppDelegate to bring additional Windows into the SwiftUI world
        let appDelegate: AppDelegateModel
        /// The body of the `View`
        var body: some View {
            VStack {
                List {
                    ForEach(appState.recentFiles, id: \.self) { url in
                        Button(
                            action: {
                                Task {
                                    do {
                                        print("RECENT")
                                        appDelegate.closeWelcomeView()
                                        try await NSDocumentController.shared.openDocument(withContentsOf: url, display: true)
                                    } catch {
                                        Logger.application.error("Error opening URL: \(error.localizedDescription, privacy: .public)")
                                    }
                                }
                            },
                            label: {
                                    Label(url.deletingPathExtension().lastPathComponent, systemImage: "doc.badge.clock")
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
                            await fileBrowser.openSong(url: song.fileURL)
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
}
