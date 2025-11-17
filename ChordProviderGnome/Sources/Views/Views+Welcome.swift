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
        /// The state of the application
        @Binding var appState: AppState
        /// The artist browser
        @State private var artists: [SongFileUtils.Artist] = []
        /// The song browser
        @State private var songs: [Song] = []
        /// The loading state
        /// - Note: For the song browser
        @State private var loadingState: Utils.LoadingState = .loading
        /// The body of the `View`
        var view: Body {
            HStack(spacing: 20) {
                VStack {
                    Text("Create a new song")
                        .style(.title)
                    Widgets.BundleImage(path: "nl.desbeers.chordprovider-mime")
                        .pixelSize(260)
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
                    Separator()
                        .style("spacer")
                        .vexpand()
                    Button("Help") {
                        openSample("Help", showEditor: false, url: true)
                    }
                    .frame(maxWidth: 250)
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
                    HStack {
                        switch appState.settings.app.welcomeTab {
                        case .recent:
                            if !appState.settings.app.recentSongs.isEmpty {
                                HStack {
                                    Button("Clear recent songs") {
                                        appState.settings.app.clearRecentSongs()
                                    }
                                    .halign(.start)
                                    .hexpand()
                                }
                            }
                        case .mySongs:
                            HStack {
                                let folder = appState.settings.app.songsFolder?.lastPathComponent
                                Button(folder ?? "Select Folder", icon: .default(icon: .folder)) {
                                    appState.scene.openFolder.signal()
                                }
                            }
                            .halign(.start)
                            .hexpand()
                        }
                        Button("Open another song") {
                            appState.scene.openSong.signal()
                        }
                        .suggested()
                        .halign(.end)
                        .valign(.start)
                    }
                    .hexpand()
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
                        loadingState = .loaded
                    }
                } else {
                    Idle {
                        loadingState = .error
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
                    StatusPage(
                        "No recent songs",
                        icon: .default(icon: .folderMusic),
                        description: "You have no recent songs."
                    )
                    .frame(minWidth: 350)
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
        }
    }
    
    /// The `View` with *My Songs* content
    @ViewBuilder var mySongs: Body {
        VStack {
            ScrollView {
                HStack {
                    if loadingState != .loaded {
                        StatusPage(
                            loadingState == .error ? "No folder selected." : "Loading songs",
                            icon: .default(icon: .folderMusic),
                            description: loadingState == .error ? "You have not selected a folder with your songs." : "One moment..."
                        )
                        .frame(minWidth: 350)
                    } else if appState.scene.search.isEmpty {
                        FlowBox(artists, selection: nil) { artist in
                            VStack {
                                Text(artist.name)
                                    .style(.title)
                                    .halign(.start)
                                Separator()
                                VStack {
                                    ForEach(artist.songs) { song in
                                        HStack {
                                            if let url = song.settings.fileURL {
                                                OpenButton(fileURL: url, title: song.metadata.title, appState: $appState)
                                                    .halign(.start)
                                            }
                                            if let tags = song.metadata.tags {
                                                HStack {
                                                    ForEach(tags.map { Markup.StringItem(string: $0) }, horizontal: true) { tag in
                                                        Text(tag.string)
                                                            .style(.tagLabel)
                                                            .padding(5, .leading)
                                                    }
                                                }
                                                .hexpand()
                                                .halign(.end)
                                                .valign(.center)
                                                .padding(10, .leading)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .rowSpacing(10)
                        .columnSpacing(10)
                    } else {
                        let result = songs.filter { $0.search.localizedCaseInsensitiveContains(appState.scene.search) }
                        if result.isEmpty {
                            StatusPage(
                                "No songs found",
                                icon: .default(icon: .systemSearch),
                                description: "Oops! We couldn't find any songs that match your search."
                            )
                            .frame(minWidth: 350)
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
                    loadingState = .loaded
                } onClose: {
                    /// Nothing to do
                }
            
        }
    }
    
    /// The tabs on the Welcome View
    enum ViewSwitcherView: String, ToggleGroupItem, CaseIterable, CustomStringConvertible, Codable {
        /// My songs
        case mySongs = "My Songs"
        /// Recent songs
        case recent = "Recent Songs"
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
                    appState.settings.core.fileURL = fileURL
                    appState.scene.showWelcome = false
                    appState.settings.app.addRecentSong(fileURL: fileURL)
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

