//
//  AppSettings+App.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension AppSettings {

    /// Settings for all **Chord Provider** scenes
    struct App: Codable {
        /// The songs folder
        var songsFolder: URL?
        /// The page layout
        var columnPaging: Bool = true
        /// The zoom factor
        var zoom: Double = 1
        /// The width of the window
        var width = 800
        /// The height of the window
        var height = 600
    }
}

extension AppSettings {

    /// Recent Song
    struct RecentSong: Identifiable, Codable {
        /// The ID of the URL
        var id = UUID()
        /// The URL
        var url: URL
        /// The title
        var title: String
        /// The artist
        var artist: String
    }
}
