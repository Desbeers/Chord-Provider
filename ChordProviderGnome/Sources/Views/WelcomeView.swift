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
        VStack(spacing: 0) {
            ScrollView {
                if let urlPath = Bundle.module.url(forResource: "nl.desbeers.chordprovider", withExtension: "svg"), let data = try? Data(contentsOf: urlPath) {
                    Picture()
                        .data(data)
                        .frame(maxWidth: 100)
                        .frame(maxHeight: 100)
                        .padding()
                }
                VStack(spacing: 20) {
                    if settings.app.recentSongs.isEmpty {
                        Button("Open a Song") {
                            settings.app.openSong.signal()
                        }
                        .halign(.center)
                    } else {
                        Text("Recent Songs", font: .title, zoom: settings.app.zoom)
                            .useMarkup()
                        VStack(spacing: 10) {
                            ForEach(settings.app.recentSongs) {songURL in
                                Button(songURL.url.lastPathComponent, icon: .default(icon: .documentOpen)) {
                                    do {
                                        let content = try SongFileUtils.getSongContent(fileURL: songURL.url)
                                        settings.app.source = content
                                        settings.app.originalSource = content
                                        settings.app.toastMessage = "Opened \(songURL.url.deletingPathExtension().lastPathComponent)"
                                        settings.app.addRecentSong(songURL: songURL.url)
                                    } catch {
                                        settings.app.toastMessage = "Could not open the song"
                                    }
                                    settings.app.showToast.signal()
                                }
                                .padding()
                            }
                        }
                        .card()
                        .frame(minWidth: 400)
                        .halign(.center)
                        .padding()
                        HStack(spacing: 10) {
                            Button("Open another Song") {
                                settings.app.openSong.signal()
                            }
                            .suggested()
                            Button("Clear recent Songs") {
                                settings.app.clearRecentSongs()
                            }
                        }
                        .halign(.center)
                    }
                    Text("Create a new song", font: .title, zoom: settings.app.zoom)
                        .useMarkup()
                    HStack(spacing: 10) {
                        Button("Open an Empty Song") {
                            settings.app.source = emptySong
                            settings.app.originalSource = emptySong
                            settings.editor.showEditor = true
                            settings.editor.splitter = settings.editor.restoreSplitter
                        }
                        .padding()
                        Button("Open a Sample Song") {
                            settings.app.source = sampleSong
                            settings.app.originalSource = sampleSong
                            settings.editor.showEditor = true
                            settings.editor.splitter = settings.editor.restoreSplitter
                        }
                        .padding()
                    }
                    .halign(.center)
                }
                .hexpand()
                .vexpand()
            }
        }
        .padding(40)
    }
}
