//
//  Views+Welcome.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import SourceView
import ChordProviderCore

extension Views {
    
    /// The `View` a new song
    struct Welcome: View {
        /// Init the `View`
        init(appState: Binding<AppState>) {
            self._appState = appState
            if let urlPath = Bundle.module.url(forResource: "nl.desbeers.chordprovider-mime", withExtension: "svg"), let data = try? Data(contentsOf: urlPath) {
                self.data = data
            }
        }
        /// The state of the application
        @Binding var appState: AppState
        /// The artist browser
        @State private var artists: [SongFileUtils.Artist] = []
        /// The song browser
        @State private var songs: [Song] = []
        /// The image data
        var data: Data? = nil
        /// The body of the `View`
        var view: Body {
            HStack(spacing: 20) {
                VStack(spacing: 20) {
                    Text("Create a new song")
                        .style(.title)
                    VStack {
                        if let data {
                            Picture()
                                .data(data)
                                .frame(minWidth: 260)
                                .frame(minHeight: 260)
                                .padding()
                        }
                        Button("Start with an empty song") {
                            openSong(content: "{title New Song}\n{artist New Artist}\n")
                        }
                        .frame(maxWidth: 250)
                        .padding()
                        Button("Open a sample song") {
                            openSample("Swing Low Sweet Chariot", showEditor: true)
                        }
                        .frame(maxWidth: 250)
                        .padding()
                        /// - Note: This should be a spacer
                        Text("")
                            .vexpand()
                        Text("<a href=\"https://www.chordpro.org\">ChordPro</a> is a simple text format for the notation of lyrics with chords.")
                            .useMarkup()
                            .wrap()
                            .padding(10, .bottom)
                            .frame(maxWidth: 250)
                        Button("Help") {
                            openSample("Help", showEditor: false, url: true)
                        }
                        .frame(maxWidth: 250)
                    }
                }
                Separator()
                VStack(spacing: 20) {
                    ToggleGroup(
                        selection: $appState.settings.app.welcomeTab,
                        values: ViewSwitcherView.allCases
                    )
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
}

extension Views.Welcome {
    
    /// The `View` with *Recent* content
    @ViewBuilder var recent: Body {
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
    @ViewBuilder var mySongs: Body {
        VStack {
            ScrollView {
                HStack {
                    if artists.isEmpty {
                        Text("Select a folder with your songs.")
                            .heading()
                    } else if appState.scene.search.isEmpty {
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
                        let result = songs.filter { $0.search.localizedCaseInsensitiveContains(appState.scene.search) }
                        if result.isEmpty {
                            StatusPage(
                                "No songs found",
                                icon: .default(icon: .systemSearch),
                                description: "Oops! We couldn't find any songs that match your search."
                            )
                        } else {
                            VStack(spacing: 10) {
                                ForEach(result) { song in
                                    if let fileURL = song.settings.fileURL {
                                        OpenButton(fileURL: fileURL, appState: $appState)
                                            .halign(.start)
                                        Text("\(song.metadata.artist) - \(song.metadata.title)")
                                            .halign(.start)
                                            .padding(30, .leading)
                                    }
                                }
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
    enum ViewSwitcherView: String, ToggleGroupItem, CaseIterable, CustomStringConvertible, Codable {
        /// Recent songs
        case recent = "Recent Songs"
        /// My songs
        case mySongs = "My Songs"
        /// The id of the tab
        var id: Self { self }
        /// The description of the tab
        var description: String {
            rawValue.capitalized
        }
        /// The icon of the tab
        var icon: Icon? {
            .default(icon: {
                switch self {
                case .recent:
                    return .documentOpenRecent
                case .mySongs:
                    return .documentOpen
                }
            }())
        }
        /// Bool to show the label
        var showLabel: Bool { true }
    }
}


extension Views.Welcome {
    
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
        /// The state of the application
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
            .style(.plainButton)
            .tooltip(fileURL.path.escapeHTML())
        }
    }
}

