//
//  AppSettings+Scale.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension AppSettings {

    /// Scaling
    struct Scale: Codable, Equatable {

        // MARK: Scaling

        /// The available width for the song
        var maxSongWidth: Double = 0

        /// The style of a song label a song label
        var songLabelStyle: AppSettings.Display.LabelStyle {
            maxSongWidth < (maxSongLabelWidth + maxSongLineWidth) ? .inline : .grid
        }
        /// Max width of a song line
        var maxSongLineWidth: Double = 340
        /// Max width of a song line
        var maxSongLabelWidth: Double = 10
        /// Scale magnifier
        var scale: Double = 1
    }
}
