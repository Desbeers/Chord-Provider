//
//  WelcomeView.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import SourceView
import ChordProviderCore
import ChordProviderHTML

/// The `View` a new song
struct WelcomeView: View {
    /// The ``AppSettings``
    @Binding var settings: AppSettings
    /// The artist browser
    @State private var artists: [SongFileUtils.Artist] = []
    /// The song browser
    @State private var songs: [Song] = []
    /// The search field
    @State private var search: String = ""
    /// The body of the `View`
    var view: Body {
        HStack(spacing: 20) {
            VStack {
                Text("Create a new song", font: .title, zoom: settings.app.zoom)
                    .useMarkup()
                VStack {
                    if let urlPath = Bundle.module.url(forResource: "nl.desbeers.chordprovider-mime", withExtension: "svg"), let data = try? Data(contentsOf: urlPath) {
                        Picture()
                            .data(data)
                            .frame(maxWidth: 200)
                            .frame(maxHeight: 200)
                            .padding()
                    }
                    Button("Start with an empty song") {
                        openSong(content: emptySong)
                    }
                    .padding()
                    Button("Open a sample song") {
                        openSong(content: sampleSong)
                    }
                    .padding()
                }
                .halign(.center)
            }
            Separator()
            VStack(spacing: 20) {
                ViewSwitcher(selectedElement: $settings.app.welcomeTab)
                    .wideDesign(true)
                switch settings.app.welcomeTab {
                case .recent: recent
                case .mySongs: mySongs
                }
            }
            .hexpand()
        }
        .vexpand()
        .padding(20)
        .onAppear {
            if !settings.app.songsFolder.isEmpty {
                Idle {
                    let url = URL(fileURLWithPath: settings.app.songsFolder)
                    let content = SongFileUtils.getSongsFromFolder(url: url, settings: settings.core, getOnlyMetadata: true)
                    artists = content.artists
                    songs = content.songs
                }
            }
        }
    }
}

extension WelcomeView {

    /// The `View` with *Recent* content
    var recent: AnyView {
        VStack(spacing: 20) {
            ScrollView {
                if settings.app.recentSongs.isEmpty {
                    Text("You have no recent songs.")
                        .heading()
                } else {
                    VStack(spacing: 10) {
                        ForEach(settings.app.recentSongs) {song in
                            OpenButton(songURL: song.url, settings: $settings)
                                .halign(.start)
                        }
                    }
                    .halign(.center)
                    .padding()
                }
            }
            .card()
            .vexpand()
            .padding(10, .bottom)
            HStack(spacing: 10) {
                Button("Open another song") {
                    settings.app.openSong.signal()
                }
                .suggested()
                if !settings.app.recentSongs.isEmpty {
                    Button("Clear recent songs") {
                        settings.app.clearRecentSongs()
                    }
                }
            }
            .halign(.center)
        }
    }

    /// The `View` with *My Songs* content
    var mySongs: AnyView {
        VStack {
            EntryRow("Search", text: $search)
                .halign(.center)
            ScrollView {
                HStack {
                    if artists.isEmpty {
                        Text("Select a folder with your songs.")
                            .heading()
                    } else if search.isEmpty {
                        ForEach(artists) { artist in
                            Text(artist.name)
                                .heading()
                                .halign(.start)
                            Separator()
                            VStack {
                                ForEach(artist.songs) { song in
                                    if let url = song.metadata.fileURL {
                                        OpenButton(songURL: url, title: song.metadata.title, settings: $settings)
                                            .halign(.end)
                                    }
                                }
                            }
                        }
                    } else {
                        ForEach(songs.filter { $0.search.localizedCaseInsensitiveContains(search) }) { song in
                            if let songURL = song.metadata.fileURL {
                                OpenButton(songURL: songURL, settings: $settings)
                                    .halign(.start)
                            }
                        }
                    }
                }
                .halign(.center)
                .padding()
            }
            .card()
            .vexpand()
            EntryRow("Folder (TODO: File Picker cannot select a folder)", text: $settings.app.songsFolder)
        }
    }
    
    /// The tabs on the Welcome View
    enum ViewSwitcherView: String, ViewSwitcherOption, CaseIterable, Codable {
        /// Recent songs
        case recent = "Recent Songs"
        /// My songs
        case mySongs = "My Songs"
        /// The title of the tab
        var title: String {
            rawValue.capitalized
        }
        /// The icon of the tab
        var icon: Icon {
            .default(icon: {
                switch self {
                case .recent:
                    return .documentOpenRecent
                case .mySongs:
                    return .documentOpen
                }
            }())
        }
    }
}

extension WelcomeView {

    /// Open a song with its content as string
    /// - Parameter content: The content of the song
    func openSong(content: String) {
        settings.app.source = content
        settings.app.originalSource = content
        settings.editor.showEditor = true
        settings.editor.splitter = settings.editor.restoreSplitter
        settings.app.showWelcome = false
    }

    /// The `View` for opening a song
    struct OpenButton: View {
        /// The song URL to open
        let songURL: URL
        /// The title of the button
        let title: String
        /// The ``AppSettings``
        @Binding var settings: AppSettings
        init(songURL: URL, title: String? = nil, settings: Binding<AppSettings>) {
            self.songURL = songURL
            self._settings = settings
            self.title = title ?? songURL.deletingPathExtension().lastPathComponent
        }
        /// The body of the `View`
        var view: Body {
            Button(title, icon: .default(icon: .folderMusic)) {
                do {
                    let content = try SongFileUtils.getSongContent(fileURL: songURL)
                    settings.app.source = content
                    settings.app.originalSource = content
                    settings.app.toastMessage = "Opened \(songURL.deletingPathExtension().lastPathComponent)"
                    settings.app.addRecentSong(songURL: songURL)
                    settings.core.songURL = songURL
                    settings.app.showWelcome = false
                } catch {
                    settings.app.toastMessage = "Could not open the song"
                }
                settings.app.showToast.signal()
            }
            .hasFrame(false)
        }
    }

}
