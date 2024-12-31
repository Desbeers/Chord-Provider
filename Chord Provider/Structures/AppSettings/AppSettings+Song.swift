//
//  AppSettings+Song.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension AppSettings {

    /// Settings for displaying a ``Song``
    struct Song: Codable, Equatable {
        /// General display options
        var display = SongDisplayOptions()
        /// Options for displaying chord diagrams
        var diagram = DiagramDisplayOptions()
    }
}
