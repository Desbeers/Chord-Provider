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
        /// The list of recent songs
        @Binding var recentSongs: RecentSongs
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
        /// The songs folder
        @State("SongsFolder") var songsFolder: URL? = nil

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
                            appState.openSample(.newSong, showEditor: true)
                        }
                        .padding()
                        Button("Open a sample song") {
                            appState.openSample(.swingLowSweetChariot, showEditor: true)
                        }
                        .padding()
                        #if DEBUG
                        Menu("Debug Songs") {
                            /// - Note: I cannot use a `ForEach` to populate the menu. It will be empty.
                            MenuButton(Utils.Samples.pangoMarkup.rawValue) {
                                appState.openSample(Utils.Samples.pangoMarkup, showEditor: true)
                            }
                            MenuButton(Utils.Samples.debugWarnings.rawValue) {
                                appState.openSample(Utils.Samples.debugWarnings, showEditor: true)
                            }
                            MenuButton(Utils.Samples.transpose.rawValue) {
                                appState.openSample(Utils.Samples.transpose, showEditor: true)
                            }
                            MenuButton(Utils.Samples.chordDefinitions.rawValue) {
                                appState.openSample(Utils.Samples.chordDefinitions, showEditor: true)
                            }
                            MenuButton(Utils.Samples.mollyMalone.rawValue) {
                                appState.openSample(Utils.Samples.mollyMalone, showEditor: true)
                            }
                        }
                        .padding()
                        #endif
                        /// - Note: This should be a spacer
                        Separator()
                            .style("spacer")
                            .vexpand()
                        Button("Help") {
                            appState.openSample(.help, showEditor: false)
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
                        values: WelcomeTab.allCases,
                        id: \.self,
                        label: \.rawValue,
                        icon: \.icon,
                        showLabel: \.showLabel
                    )
                    switch welcomeTab {
                    case .mySongs: mySongsView
                    case .myTags: myTagsView
                    case .recentSongs: recentSongsView
                    }
                    HStack {
                        switch welcomeTab {
                        case .recentSongs:
                            if !recentSongs.getRecentSongs().isEmpty {
                                HStack {
                                    Button("Clear recent songs") {
                                        recentSongs.clearRecentSongs()
                                    }
                                    .halign(.start)
                                    .hexpand()
                                }
                            }
                        case .mySongs, .myTags:
                            HStack {
                                let folder = songsFolder?.lastPathComponent
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
                open: appState.scene.openFolder
            ) { folderURL in
                songsFolder = folderURL
                getFolderContent()
            }

            // MARK: Top Toolbar

            .topToolbar {
                Views.Toolbar.Welcome(
                    app: app,
                    window: window,
                    welcomeTab: welcomeTab,
                    appState: $appState,
                    search: $search,
                    songsFolder: songsFolder
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
            if let url = songsFolder {
                let content = SongFileUtils.getSongsFromFolder(
                    url: url,
                    settings: appState.editor.song.settings,
                    getOnlyMetadata: true
                )
                artists = content.artists
                songs = content.songs
                /// Don't show tags with links; they are very specific for the song
                let tags = songs.compactMap(\.metadata.tags).flatMap { $0 }.filter { !$0.content.contains("http") }
                /// Make sure the tags are unique
                self.tags = tags.uniqued(by: \.content).sorted()
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
    enum WelcomeTab: String, CaseIterable, CustomStringConvertible, Codable {
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
        metadata: Song.Metadata,
        songTitleOnly: Bool = false
    ) -> Body {
        HStack {
            Button("") {
                appState.openSong(fileURL: fileURL)
                recentSongs.addRecentSong(
                    content: appState.scene.originalContent,
                    settings: appState.editor.song.settings
                )
                appState.scene.showToast.signal()
            }
            .child {
                HStack {
                    VStack {
                        Text(metadata.title)
                            .halign(.start)
                            .style(songTitleOnly ? .plainButton : .subtitle)
                            .hexpand()
                        if !songTitleOnly {
                            Text(metadata.artist)
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
            .tooltip(fileURL.lastPathComponent.escapeSpecialCharacters())
            if let tags = metadata.tags  {
                Views.Tags(tags: tags)
                    .valign(.center)
            }
        }
    }
}
