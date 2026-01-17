//
//  Views+Welcome.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
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
        @State var artists: [SongFileUtils.Artist] = []
        /// The song browser
        @State var songs: [Song] = []
        /// The tags browser
        @State var tags: [String.ElementWrapper] = []
        /// The loading state
        /// - Note: For the song browser
        @State var loadingState: Views.LoadingState = .loading
        /// The tab to show
        @State private var welcomeTab: WelcomeTab = .mySongs
        /// The optional search string
        @State var search: String = ""
        /// The selected tag
        @State var selectedTab: String.ElementWrapper.ID = .init()

        // MARK: Main View

        /// The Main `View`
        var view: Body {
            HStack(spacing: 20) {
                VStack {
                    Text("Create a new song")
                        .style(.title)
                    Widgets.BundleImage(path: "nl.desbeers.chordprovider-mime")
                        .pixelSize(260)
                    VStack {
                        Button("Start with a new song") {
                            appState.openSample("New Song", showEditor: true)
                        }
                        .padding()
                        Button("Open a sample song") {
                            appState.openSample("Swing Low Sweet Chariot", showEditor: true)
                        }
                        .padding()
                        /// - Note: This should be a spacer
                        Separator()
                            .style("spacer")
                            .vexpand()
                        Button("Help") {
                            appState.openSample("Help", showEditor: false)
                        }
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
                    case .mySongs: mySongs
                    case .myTags: myTags
                    case .recentSongs: recentSongs
                    }
                    HStack {
                        switch welcomeTab {
                        case .recentSongs:
                            if !appState.getRecentSongs().isEmpty {
                                HStack {
                                    Button("Clear recent songs") {
                                        appState.clearRecentSongs()
                                    }
                                    .halign(.start)
                                    .hexpand()
                                }
                            }
                        case .mySongs, .myTags:
                            HStack {
                                let folder = appState.settings.app.songsFolder?.lastPathComponent
                                Button(folder ?? "Select Folder", icon: .default(icon: .folder)) {
                                    appState.scene.openFolder.signal()
                                }
                                .tooltip("The folder with you songs")
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

            // MARK: Song Folder importer

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

// MARK: Helper functions

extension Views.Welcome {

    // MARK: Get folder content

    /// Get the content of a folder with songs
    func getFolderContent() {
        Idle {
            if let url = appState.settings.app.songsFolder {
                let content = SongFileUtils.getSongsFromFolder(
                    url: url,
                    settings: appState.editor.song.settings,
                    getOnlyMetadata: true
                )
                artists = content.artists
                songs = content.songs
                /// Don't show thags with links; they are very specific for the song
                let tags = songs.compactMap(\.metadata.tags).flatMap { $0 }.filter { !$0.contains("http") }
                /// Make sure the tags are unique
                self.tags = Array(Set(tags).sorted()).toElementWrapper()
                /// The songs are loaded
                loadingState = .loaded
            } else {
                loadingState = .error
            }
        }
    }
}

extension Views.Welcome {

    // MARK: Welcome Tabs

    /// The tabs on the Welcome View
    enum WelcomeTab: String, ToggleGroupItem, CaseIterable, CustomStringConvertible, Codable {
        /// My songs
        case mySongs = "My Songs"
        /// My tags
        case myTags = "My Tags"
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
                case .mySongs:
                        .documentOpen
                case .myTags:
                        .userBookmarks
                case .recentSongs:
                        .documentOpenRecent
                }
            }())
        }
        /// Bool to show the label
        var showLabel: Bool { true }
    }
}


extension Views.Welcome {

    // MARK: Open Button

    /// Open a song
    /// - Parameters:
    ///   - fileURL: The URL of the song
    ///   - song: The song itself
    ///   - songTitleOnly: Show only the song title
    /// - Returns: A `Body`
    @ViewBuilder func openButton(
        fileURL: URL,
        song: Song,
        songTitleOnly: Bool = false
    ) -> Body {
        HStack {
            Button("") {
                appState.openSong(fileURL: fileURL)
                appState.scene.showToast.signal()
            }
            .child {
                HStack {
                    VStack {
                        Text(song.metadata.title)
                            .halign(.start)
                            .style(songTitleOnly ? .plainButton : .subtitle)
                            .hexpand()
                        if !songTitleOnly {
                            Text(song.metadata.artist)
                                .halign(.start)
                                .style(.plainButton)
                        }
                    }
                    .valign(.center)
                }
                .valign(.center)
                .frame(minWidth: songTitleOnly ? 0 : 300)
            }
            .hasFrame(false)
            .tooltip(fileURL.path.escapeSpecialCharacters())
            if let tags = song.metadata.tags  {
                Views.Tags(tags: tags)
                    .valign(.center)
            }
        }
    }
}
