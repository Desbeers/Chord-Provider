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
    /// The song browser
    @State private var songBrowser: [SongFileUtils.Artist] = []
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
                        settings.app.source = emptySong
                        settings.app.originalSource = emptySong
                        settings.editor.showEditor = true
                        settings.editor.splitter = settings.editor.restoreSplitter
                        settings.app.showWelcome = false
                    }
                    .padding()
                    Button("Open a sample song") {
                        settings.app.source = sampleSong
                        settings.app.originalSource = sampleSong
                        settings.editor.showEditor = true
                        settings.editor.splitter = settings.editor.restoreSplitter
                        settings.app.showWelcome = false
                    }
                    .padding()
                }
                .halign(.center)
            }
            //.hexpand()
            //.frame(maxWidth: 300)
            Separator()
            VStack(spacing: 20) {
                ViewSwitcher(selectedElement: $settings.app.welcomeTab)
                    .wideDesign(true)
                //                Text(selection.rawValue, font: .title, zoom: settings.app.zoom)
                //                    .useMarkup()
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
                    songBrowser = content.artists
                }
            }
        }
    }
}

extension WelcomeView {
    
    var recent: AnyView {
        VStack(spacing: 20) {
            ScrollView {
                if settings.app.recentSongs.isEmpty {
                    Text("You have no recent songs.")
                        .heading()
                } else {
                    VStack(spacing: 10) {
                        ForEach(settings.app.recentSongs) {songURL in
                            Button(songURL.url.deletingPathExtension().lastPathComponent, icon: .default(icon: .documentOpen)) {
                                do {
                                    let content = try SongFileUtils.getSongContent(fileURL: songURL.url)
                                    settings.app.source = content
                                    settings.app.originalSource = content
                                    settings.app.toastMessage = "Opened \(songURL.url.deletingPathExtension().lastPathComponent)"
                                    settings.app.addRecentSong(songURL: songURL.url)
                                    settings.core.songURL = songURL.url
                                    settings.app.showWelcome = false
                                } catch {
                                    settings.app.toastMessage = "Could not open the song"
                                }
                                settings.app.showToast.signal()
                            }
                            .hasFrame(false)
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
            //}
        }
        //.hexpand()
    }
    
    var mySongs: AnyView {
        VStack {
            ScrollView {
                HStack {
                    if songBrowser.isEmpty {
                        Text("Select a folder with your songs.")
                            .heading()
                    } else {
                        ForEach(songBrowser) { artist in
                            Text(artist.name)
                                .heading()
                                .halign(.start)
                            Separator()
                            VStack {
                                ForEach(artist.songs) { song in
                                    Button(song.metadata.title, icon: .default(icon: .documentOpen)) {
                                        if let url = song.metadata.fileURL, let content = try? String(contentsOf: url, encoding: .utf8) {
                                            settings.core.songURL = url
                                            settings.app.source = content
                                            settings.app.originalSource = content
                                            /// Show the toast
                                            settings.app.toastMessage = "Opened \(url.deletingPathExtension().lastPathComponent)"
                                            settings.app.showToast.signal()
                                            /// Append to recent
                                            settings.app.addRecentSong(songURL: url)
                                            /// Hide the welcome
                                            settings.app.showWelcome = false
                                        }
                                    }
                                    .hasFrame(false)
                                    .halign(.end)
                                }
                            }
                            .halign(.end)
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
    
    enum ViewSwitcherView: String, ViewSwitcherOption, CaseIterable, Codable {
        
        case recent = "Recent Songs"
        case mySongs = "My Songs"
        
        var title: String {
            rawValue.capitalized
        }
        
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
