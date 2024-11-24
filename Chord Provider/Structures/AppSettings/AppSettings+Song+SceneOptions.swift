//
//  AppSettings+Song+SceneOptions.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 22/11/2024.
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
