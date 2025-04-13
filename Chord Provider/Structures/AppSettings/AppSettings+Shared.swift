//
//  AppSettings+Song.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension AppSettings {

    /// Settings shared by all scenes
    struct Shared: Equatable, Codable, Sendable {
        /// Repeat the whole last chorus when using a *{chorus}* directive
        var repeatWholeChorus: Bool = false
        /// Show only lyrics
        var lyricsOnly: Bool = false
    }
}
