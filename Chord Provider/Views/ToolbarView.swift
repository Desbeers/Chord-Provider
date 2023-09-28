//
//  ToolbarView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyFolderUtilities

/// Swiftui `View` for the toolbar
struct ToolbarView: View {
    /// The ``song``
    @Binding var song: Song
    /// The scene state
    @EnvironmentObject private var sceneState: SceneState
    /// The body of the `View`
    var body: some View {
        HStack {
            Button(action: {
                song.transpose -= 1
            }, label: {
                Label("♭", systemImage: "arrow.down")
                    .foregroundColor(song.transpose < 0 ? .primary : .secondary)
            })
            Button(action: {
                song.transpose += 1
            }, label: {
                Label("♯", systemImage: "arrow.up")
                    .foregroundColor(song.transpose > 0 ? .primary : .secondary)
            })
            Button {
                sceneState.showEditor.toggle()
            } label: {
                Label("Edit", systemImage: sceneState.showEditor ? "pencil.circle.fill" : "pencil.circle")
            }
            Button {
                sceneState.showChords.toggle()
            } label: {
                Label("Chords", systemImage: sceneState.showChords ? "number.circle.fill" : "number.circle")
            }
        }
        .labelStyle(.titleAndIcon)
    }
}

extension ToolbarView {

    /// SwiftUI `View` with a slider to zoom the content
    struct ScaleSlider: View {
        /// Current scaling of the `SongView`
        @SceneStorage("scale") var scale: Double = 1.2
        /// The body of the `View`
        var body: some View {
            Slider(value: $scale, in: 0.8...2.0) {
                Label("Zoom", systemImage: "magnifyingglass")
            }
            .labelStyle(.iconOnly)
        }
    }
}

extension ToolbarView {

    /// SwiftUI `View` with optional player buttons
    struct PlayerButtons: View {
        /// The ``Song``
        let song: Song
        /// The optional file location
        let file: URL?
        /// The body of the `View`
        var body: some View {
            if let musicURL = getMusicURL() {
                AudioPlayerView(musicURL: musicURL)
                    .padding(.leading)
            } else {
                EmptyView()
            }
        }
        /// Get the URL for the music file
        /// - Returns: A full URL to the file, if found
        private func getMusicURL() -> URL? {
            guard let file, let path = song.musicPath else {
                return nil
            }
            var musicURL = file.deletingLastPathComponent()
            musicURL.appendPathComponent(path)
            return musicURL
        }
    }
}

extension ToolbarView {

    /// SwiftUI `View` for the folder selector
    struct FolderSelector: View {
        /// The FileBrowser model
        @StateObject var fileBrowser: FileBrowser = .shared
        /// Folder selector title
        private var folderTitle: String {
            FolderBookmark.getBookmarkL(bookmark: FileBrowser.bookmark)?.lastPathComponent ?? "Not selected"
        }
        var body: some View {
            FolderBookmark.SelectFolder(
                bookmark: FileBrowser.bookmark,
                title: folderTitle,
                systemImage: "folder"
            ) {
                Task { @MainActor in
                    await fileBrowser.getFiles()
                }
            }
        }
    }
}
