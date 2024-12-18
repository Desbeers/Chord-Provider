//
//  AppSettings+Song+SceneOptions.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension AppSettings.Song {

    struct SceneOptions: Codable, Equatable {
        /// Repeat the whole last chorus when using a *{chorus}* directive
        var repeatWholeChorus: Bool = false
        /// Show only lyrics
        var lyricsOnly: Bool = false
    }
}
