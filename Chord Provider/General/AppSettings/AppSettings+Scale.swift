//
//  AppSettings+Scale.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension AppSettings {

    /// Scaling of a song
    struct Scale: Codable, Equatable {

        // MARK: Scaling

        /// The available width for the song
        var maxSongWidth: Double = 0
        /// Max width of a song line
        var maxSongLineWidth: Double = 340
        /// Max width of a song line
        var maxSongLabelWidth: Double = 10
        /// Scale magnifier
        var magnifier: Double = 1
    }
}
