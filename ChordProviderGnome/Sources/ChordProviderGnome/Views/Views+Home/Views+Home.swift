//
//  Views+Home.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension Views {

    /// The `View` for the start page of **Chord Provider**
    struct Home: View {
        /// The app
        let app: AdwaitaApp
        /// The window
        let window: AdwaitaWindow
        /// The state of the application
        @Binding var appState: AppState
        /// The list of recent songs
        @Binding var recentSongs: RecentSongs

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
                            appState.openSample(.newSong, showEditor: true)
                        }
                        .padding()
                        Button("Open a sample song") {
                            appState.openSample(.swingLowSweetChariot, showEditor: true)
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
                        selection: $appState.home.tab,
                        values: AppState.Home.Tab.allCases,
                        id: \.self,
                        label: \.rawValue,
                        icon: \.icon,
                        showLabel: \.showLabel
                    )
                    switch appState.home.tab {
                    case .mySongs:
                        mySongsView
                    case .myTags:
                        myTagsView
                    case .recentSongs:
                        recentSongsView
                    }
                    HStack {
                        switch appState.home.tab {
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
                                let folder = appState.home.songsFolder?.lastPathComponent
                                Button(folder ?? "Select Folder", icon: .default(icon: .folder)) {
                                    appState.scene.openFolder.signal()
                                }
                                .tooltip("The folder with you songs")
                                .padding(.trailing)
                                if let randomSong = appState.home.randomSong, let url = randomSong.settings.fileURL {
                                    HStack {
                                        Button(icon: .default(icon: .mediaPlaylistShuffle)) {
                                            appState.setRandomSong()
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

            // MARK: Song Folder importer

            .folderImporter(
                open: appState.scene.openFolder
            ) { folderURL in
                appState.home.songsFolder = folderURL
                appState.getFolderContent()
            }

            // MARK: Top Toolbar

            .topToolbar {
                Views.Toolbar.Home(
                    app: app,
                    window: window,
                    appState: $appState
                )
            }
        }

        /// Debug songs menu
        private func debugSongsMenu() -> Menu {
            var result: [MenuButton] = []
            for sample in Utils.Samples.debugSamples {
                result.append(MenuButton(sample.rawValue) { appState.openSample(sample, showEditor: true) })
            }
            return Menu("Debug Songs") { result }
        }
    }
}
