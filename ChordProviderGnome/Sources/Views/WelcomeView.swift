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
    /// The body of the `View`
    var view: Body {
        VStack {
            HStack(spacing: 20) {
                VStack(spacing: 20) {
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
                .hexpand()
                Separator()
                VStack(spacing: 20) {
                    Text("Recent Songs", font: .title, zoom: settings.app.zoom)
                        .useMarkup()
                    if settings.app.recentSongs.isEmpty {
                        Text("You have no recent songs", font: .subtitle, zoom: settings.app.zoom)
                            .useMarkup()
                            .padding(20, .bottom)
                        Button("Open a song") {
                            settings.app.openSong.signal()
                        }
                        .halign(.center)
                        .valign(.center)
                        .suggested()
                    } else {
                        ScrollView {
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
                        .card()
                        .vexpand()
                        .padding()
                        HStack(spacing: 10) {
                            Button("Open another song") {
                                settings.app.openSong.signal()
                            }
                            .suggested()
                            Button("Clear recent songs") {
                                settings.app.clearRecentSongs()
                            }
                        }
                        .halign(.center)
                        //.hexpand()
                    }
                }
                .hexpand()
            }
            //.hexpand()
            .vexpand()
        }
        .padding(40)
    }
}
