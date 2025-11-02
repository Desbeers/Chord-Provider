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
    /// The ``AppState``
    @Binding var appState: AppState
    /// The artist browser
    @State private var artists: [SongFileUtils.Artist] = []
    /// The song browser
    @State private var songs: [Song] = []
    /// The search field
    @State private var search: String = ""
    /// The body of the `View`
    var view: Body {
        HStack(spacing: 20) {
            VStack(spacing: 20) {
                Text("Create a new song")
                    .style(.title)
                VStack {
                    if let urlPath = Bundle.module.url(forResource: "nl.desbeers.chordprovider-mime", withExtension: "svg"), let data = try? Data(contentsOf: urlPath) {
                        Picture()
                            .data(data)
                            .frame(maxWidth: 200)
                            .frame(maxHeight: 200)
                            .padding()
                    }
                    Button("Start with an empty song") {
                        openSong(content: "{title New Song}\n{artist New Artist}\n")
                    }
                    .padding()
                    Button("Open a sample song") {
                        openSample("Swing Low Sweet Chariot", showEditor: true)
                    }
                    .padding()
                    /// - Note: This should be a spacer
                    Text("")
                        .vexpand()
                    Button("Help") {
                        Idle {
                            openSample("Help", showEditor: false, url: true)
                        }
                    }
                    //.padding(5, .bottom)
                }
                .halign(.center)
            }
            Separator()
            VStack(spacing: 20) {
                ViewSwitcher(selectedElement: $appState.settings.app.welcomeTab)
                    .wideDesign(true)
                switch appState.settings.app.welcomeTab {
                case .recent: recent
                case .mySongs: mySongs
                }
            }
            .hexpand()
        }
        .vexpand()
        .padding(20)
        .onAppear {
            if let url = appState.settings.app.songsFolder {
                Idle {
                    let content = SongFileUtils.getSongsFromFolder(url: url, settings: appState.settings.core, getOnlyMetadata: true)
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
                if appState.settings.app.recentSongs.isEmpty {
                    Text("You have no recent songs.")
                        .heading()
                } else {
                    VStack(spacing: 10) {
                        ForEach(appState.settings.app.getRecentSongs()) {song in
                            OpenButton(fileURL: song.url, appState: $appState)
                                .halign(.start)
                            Text("\(song.artist) - \(song.title)")
                                .halign(.start)
                                .padding(30, .leading)
                        }
                    }
                    .halign(.center)
                    .padding()
                }
            }
            .card()
            .vexpand()
            HStack(spacing: 10) {
                Button("Open another song") {
                    appState.scene.openSong.signal()
                }
                .suggested()
                if !appState.settings.app.recentSongs.isEmpty {
                    Button("Clear recent songs") {
                        appState.settings.app.clearRecentSongs()
                    }
                }
            }
            .halign(.center)
        }
    }

    /// The `View` with *My Songs* content
    var mySongs: AnyView {
        VStack {
            SearchEntry()
                .text($search)
                .placeholderText("Search")
                .padding(5, .bottom)
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
                                    if let url = song.settings.fileURL {
                                        OpenButton(fileURL: url, title: song.metadata.title, appState: $appState)
                                            .halign(.end)
                                    }
                                }
                            }
                        }
                    } else {
                        ForEach(songs.filter { $0.search.localizedCaseInsensitiveContains(search) }) { song in
                            if let fileURL = song.settings.fileURL {
                                OpenButton(fileURL: fileURL, appState: $appState)
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
            .padding(20, .bottom)
            HStack(spacing: 20) {
                Text("The folder with your songs:")
                Button(appState.settings.app.songsFolder?.lastPathComponent ?? "Select folder") {
                    appState.scene.openFolder.signal()
                }
            }
            .halign(.center)
            .folderImporter(
                open: appState.scene.openFolder) { folderURL in
                    appState.settings.app.songsFolder = folderURL
                    let content = SongFileUtils.getSongsFromFolder(
                        url: folderURL,
                        settings: appState.settings.core,
                        getOnlyMetadata: true
                    )
                    artists = content.artists
                    songs = content.songs
                } onClose: {
                    /// Nothing to do
                }

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

    func openSample(_ sample: String, showEditor: Bool = true, url: Bool = false) {
        if
            let sampleSong = Bundle.module.url(forResource: "Samples/Songs/\(sample)", withExtension: "chordpro"),
            let content = try? String(contentsOf: sampleSong, encoding: .utf8) {
            openSong(content: content, showEditor: showEditor, url: url ? sampleSong : nil)
        } else {
            print("Error loading sample song")
        }
    }

    /// Open a song with its content as string
    /// - Parameter content: The content of the song
    func openSong(content: String, showEditor: Bool = true, url: URL? = nil) {
        appState.scene.source = content
        appState.scene.originalSource = content
        appState.settings.editor.showEditor = showEditor
        if showEditor {
            appState.settings.editor.splitter = appState.settings.editor.restoreSplitter
        }
        if let url {
            appState.settings.core.templateURL = url
        }
        appState.scene.showWelcome = false
    }

    /// The `View` for opening a song
    struct OpenButton: View {
        /// The file URL to open
        let fileURL: URL
        /// The title of the button
        let title: String
        /// The ``AppState``
        @Binding var appState: AppState
        init(fileURL: URL, title: String? = nil, appState: Binding<AppState>) {
            self.fileURL = fileURL
            self._appState = appState
            self.title = title ?? fileURL.deletingPathExtension().lastPathComponent
        }
        /// The body of the `View`
        var view: Body {
            Button(title, icon: .default(icon: .folderMusic)) {
                do {
                    let content = try SongFileUtils.getSongContent(fileURL: fileURL)
                    appState.scene.source = content
                    appState.scene.originalSource = content
                    appState.scene.toastMessage = "Opened \(fileURL.deletingPathExtension().lastPathComponent)"
                    appState.settings.app.addRecentSong(fileURL: fileURL)
                    appState.settings.core.fileURL = fileURL
                    appState.scene.showWelcome = false
                } catch {
                    appState.scene.toastMessage = "Could not open the song"
                }
                appState.scene.showToast.signal()
            }
            .hasFrame(false)
            .tooltip(fileURL.path.escapeHTML())
        }
    }
}
