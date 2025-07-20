//
//  AppSettings+Application.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension AppSettings {

    /// Settings that will change the behaviour of the application
    struct Application: Codable, Equatable {
        /// Bool to use a custom song template
        var useCustomSongTemplate: Bool = false
        /// List of articles to ignore when sorting songs and artists
        var sortTokens: [String] = ["the", "a", "de", "een", "’t"]
        /// Sorting of song lists
        var songListSort: SongListSort = .artist
        /// Repeat the whole last chorus when using a *{chorus}* directive
        var repeatWholeChorus: Bool = false
        /// Show only lyrics
        var lyricsOnly: Bool = false
    }
}
