//
//  AppSettings+AppWindowID.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension AppSettings {

    /// The ID of the app window
    /// - Note: Used to load and save the settings in the cache
    enum AppWindowID: String {
        /// `MainView` settings
        case mainView = "Main Settings"
        /// `ExportFolderView` settings
        case exportFolderView = "Export Settings"
        /// `ChordsDatabaseView` settings
        case chordsDatabaseView = "Database Settings"
    }
}
