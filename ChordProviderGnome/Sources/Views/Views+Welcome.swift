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
        /// The app
        let app: AdwaitaApp
        /// The window
        let window: AdwaitaWindow
        /// The state of the application
        @Binding var appState: AppState
        /// The artist browser
        @State private var artists: [SongFileUtils.Artist] = []
        /// The song browser
        @State private var songs: [Song] = []
        /// The loading state
        /// - Note: For the song browser
        @State private var loadingState: Views.LoadingState = .loading

        @State private var welcomeTab: WelcomeTab = .mySongs

        @State private var search: String = ""

        // MARK: Main View

        /// The Main `View`
        var view: Body {
            HStack(spacing: 20) {
                VStack {
                    Text("Create a new song")
                        .style(.title)
                    Widgets.BundleImage(path: "nl.desbeers.chordprovider-mime")
                        .pixelSize(260)
                    Button("Start with an empty song") {
                        appState.openSong(content: "{title New Song}\n{artist New Artist}\n")
                    }
                    .frame(maxWidth: 250)
                    .padding()
                    Button("Open a sample song") {
                        appState.openSample("Swing Low Sweet Chariot", showEditor: true)
                    }
                    .frame(maxWidth: 250)
                    .padding()
                    /// - Note: This should be a spacer
                    Separator()
                        .style("spacer")
                        .vexpand()
                    Button("Help") {
                        appState.openSample("Help", showEditor: false, url: true)
                    }
                    .frame(maxWidth: 250)
                }
                Separator()
                VStack(spacing: 20) {
                    /// - Note: The selection must be a single variable; it cannot be a struct
                    ///
                    /// When opening a song at launch and go back to this View you will get a crash otherwise
                    ToggleGroup(
                        selection: $welcomeTab,
                        values: WelcomeTab.allCases
                    )
                    switch welcomeTab {
                    case .recentSongs: recentSongs
                    case .mySongs: mySongs
                    }
                    HStack {
                        switch welcomeTab {
                        case .recentSongs:
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
                getFolderContent()
            }
            .folderImporter(
                open: appState.scene.openFolder,
                initialFolder: appState.settings.app.songsFolder
            ) { folderURL in
                appState.settings.app.songsFolder = folderURL
                getFolderContent()
            }

            // MARK: Top Toolbar

            .topToolbar {
                Views.Toolbar.Welcome(
                    app: app,
                    window: window,
                    welcomeTab: welcomeTab,
                    appState: $appState,
                    search: $search
                )
            }
        }
    }
}

extension Views.Welcome {

    // MARK: - Recent Songs View

    /// The `View` with **Recent** songs
    @ViewBuilder var recentSongs: Body {
        VStack(spacing: 20) {
            ScrollView {
                if appState.getRecentSongs().isEmpty {
                    StatusPage(
                        "No recent songs",
                        icon: .default(icon: .folderMusic),
                        description: "You have no recent songs."
                    )
                    .frame(minWidth: 350)
                } else {
                    VStack(spacing: 10) {
                        ForEach(appState.getRecentSongs()) { recent in
                            openButton(fileURL: recent.url, song: recent.song)
//                            OpenButton(fileURL: recent.url, appState: $appState)
//                                .halign(.start)
//                            Text("\(recent.song.metadata.artist) - \(recent.song.metadata.title)")
//                                .halign(.start)
//                                .padding(30, .leading)
//                                .style(.plainButton)
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
}

extension Views.Welcome {

    // MARK: - My Songs View

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
                        .transition(.crossfade)
                    } else if search.isEmpty {
                        FlowBox(artists, selection: nil) { artist in
                            VStack {
                                Text(artist.name)
                                    .style(.subtitle)
                                    .halign(.start)
                                Separator()
                                VStack {
                                    ForEach(artist.songs) { song in
                                        if let url = song.settings.fileURL {
                                            openButton(fileURL: url, song: song, artistView: false)
                                        }
                                    }
                                }
                            }
                        }
                        .rowSpacing(10)
                        .columnSpacing(10)
                        .transition(.crossfade)
                    } else {
                        let result = songs.filter { $0.search.localizedCaseInsensitiveContains(search) }
                        if result.isEmpty {
                            StatusPage(
                                "No songs found",
                                icon: .default(icon: .systemSearch),
                                description: "Oops! We couldn't find any songs that match your search."
                            )
                            .frame(minWidth: 350)
                            .transition(.crossfade)
                        } else {
                            VStack(spacing: 10) {
                                ForEach(result) { song in
                                    if let fileURL = song.settings.fileURL {
                                        openButton(fileURL: fileURL, song: song)
//                                        OpenButton(
//                                            fileURL: fileURL,
//                                            appState: $appState,
//                                            tags: song.metadata.tags
//                                        )
//                                        .halign(.start)
//                                        Text("\(song.metadata.artist) - \(song.metadata.title)")
//                                            .halign(.start)
//                                            .padding(30, .leading)
//                                            .style(.plainButton)
                                    }
                                }
                            }
                            .transition(.crossfade)
                        }
                    }
                }
                .halign(.center)
                .padding()
            }
            .card()
            .vexpand()
        }
    }
}

// MARK: - Helper functions

extension Views.Welcome {
    
    /// Get the content of a folder with songs
    func getFolderContent() {
        Idle {
            if let url = appState.settings.app.songsFolder {
                let content = SongFileUtils.getSongsFromFolder(
                    url: url,
                    settings: appState.settings.core,
                    getOnlyMetadata: true
                )
                artists = content.artists
                songs = content.songs
                loadingState = .loaded
            } else {
                loadingState = .error
            }
        }
    }
}

extension Views.Welcome {

    // MARK: - Welcome Tabs

    /// The tabs on the Welcome View
    enum WelcomeTab: String, ToggleGroupItem, CaseIterable, CustomStringConvertible, Codable {
        /// My songs
        case mySongs = "My Songs"
        /// Recent songs
        case recentSongs = "Recent Songs"
        /// The id of the tab
        var id: Self { self }
        /// The description of the tab
        var description: String {
            rawValue
        }
        /// The icon of the tab
        var icon: Icon? {
            .default(icon: {
                switch self {
                case .recentSongs:
                        .documentOpenRecent
                case .mySongs:
                        .documentOpen
                }
            }())
        }
        /// Bool to show the label
        var showLabel: Bool { true }
    }
}


extension Views.Welcome {

    @ViewBuilder func openButton(fileURL: URL, song: Song, artistView: Bool = true) -> Body {
        Button("") {
            appState.openSong(fileURL: fileURL)
            appState.scene.showToast.signal()
        }
        .child {
            HStack {
                VStack {
                    Text(song.metadata.title)
                        .halign(.start)
                        .style(.plainButton)
                        .hexpand()
                    if artistView {
                        Text(song.metadata.artist)
                            .halign(.start)
                            .style("capture")

                    }
                }
                if let tags = song.metadata.tags  {
                    HStack {
                        ForEach(tags.map { Markup.StringItem(string: $0) }, horizontal: true) { tag in
                            Text(tag.string)
                                .style(.tagLabel)
                                .padding(5, .leading)
                                .valign(.start)
                        }
                    }
                }
            }
        }
        .hasFrame(false)
        .tooltip(fileURL.path.escapeHTML())

    }


    /// The `View` for opening a song
    struct AAOpenButton: View {
        /// The file URL to open
        let fileURL: URL
        /// The title of the button
        let title: String
        /// The state of the application
        @Binding var appState: AppState
        /// The optional tags
        var tags: [String]?
        /// The style
        let style: Markup.Class
        /// Init the struct
        init(fileURL: URL, title: String? = nil, appState: Binding<AppState>, tags: [String]? = nil) {
            self.fileURL = fileURL
            self._appState = appState
            self.title = title ?? fileURL.deletingPathExtension().lastPathComponent
            self.tags = tags
            self.style = title == nil ? .subtitle : .plainButton
        }
        /// The body of the `View`
        var view: Body {
            Button("") {
                appState.openSong(fileURL: fileURL)
                appState.scene.showToast.signal()
            }
            .child {
                HStack {
                    Text(title)
                        .halign(.start)
                        .hexpand()
                        .style(style)
                    if let tags  {
                        HStack {
                            ForEach(tags.map { Markup.StringItem(string: $0) }, horizontal: true) { tag in
                                Text(tag.string)
                                    .style(.tagLabel)
                                    .padding(5, .leading)
                                    .valign(.start)
                            }
                        }
                    }
                }
            }
            .hasFrame(false)
            .tooltip(fileURL.path.escapeHTML())
        }
    }
}
