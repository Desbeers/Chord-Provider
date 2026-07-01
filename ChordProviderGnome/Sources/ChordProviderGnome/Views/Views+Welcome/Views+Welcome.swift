//
//  Views+Welcome.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
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
        /// Random song
        @State var randomSong: Song?
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
        // swiftlint:disable implicit_optional_initialization
        /// The songs folder
        @State("SongsFolder")
        var songsFolder: URL? = nil
        // swiftlint:enable implicit_optional_initialization

        // MARK: Main View

        /// The Main `View`
        var view: Body {
            HStack(spacing: 20) {
                VStack {
                    Text("Create a new song")
                        .style(.title)
                    Widgets.BundleImage(path: "nl.desbeers.chordprovider")
                        .pixelSize(220)
                        .halign(.center)
                        .padding(10)
                    VStack {
                        Button("Start with a new song") {
                            openSample(.newSong, showEditor: true)
                        }
                        .padding()
                        Button("Open a sample song") {
                            openSample(.swingLowSweetChariot, showEditor: true)
                        }
                        .padding()
                        if appState.settings.app.debug {
                            debugSongsMenu()
                                .padding()
                        }
                        /// - Note: This should be a spacer
                        Separator()
                            .style("spacer")
                            .vexpand()
                        Button("Help") {
                            openSample(.help, showEditor: false)
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
                    case .mySongs:
                        mySongsView
                    case .myTags:
                        myTagsView
                    case .recentSongs:
                        recentSongsView
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
                                .padding(.trailing)
                                if let randomSong, let url = randomSong.settings.fileURL {
                                    HStack {
                                        Button(icon: .default(icon: .mediaPlaylistShuffle)) {
                                            setRandomSong()
                                        }
                                        .flat()
                                        openButton(
                                            fileURL: url,
                                            metadata: randomSong.metadata,
                                            songTitleOnly: true,
                                            showTags: false
                                        )
                                    }
                                }
                            }
                            .halign(.start)
                            .hexpand()
                        }
                        // if let randomSong, let url = randomSong.settings.fileURL {
                        //     HStack {
                        //         Button(icon: .default(icon: .mediaPlaylistShuffle)) {
                        //             setRandomSong()
                        //         }
                        //         .flat()
                        //         openButton(
                        //             fileURL: url,
                        //             metadata: randomSong.metadata,
                        //             songTitleOnly: true,
                        //             showTags: false
                        //         )
                        //     }
                        //     .halign(.start)
                        //     .padding(.leading)
                        // }
                        Button("Open another song") {
                            appState.scene.openSong.signal()
                        }
                        .suggested()
                        .halign(.end)
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

        /// Debug songs menu
        private func debugSongsMenu() -> Menu {
            var result: [MenuButton] = []
            for sample in Utils.Samples.debugSamples {
                result.append(MenuButton(sample.rawValue) { openSample(sample, showEditor: true) })
            }
            return Menu("Debug Songs") { result }
        }
    }
}
