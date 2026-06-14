//
//  AppSettings+Application.swift
//  Chord Provider
//
//  © 2026 Nick Berendsen
//

import Foundation

extension AppSettings {

    /// Settings that will change the behaviour of the application
    struct Application: Codable, Equatable {
        /// Bool to use a custom song template
        var useCustomSongTemplate: Bool = false
        /// Sorting of song lists
        var songListSort: SongListSort = .artist
    }
}
