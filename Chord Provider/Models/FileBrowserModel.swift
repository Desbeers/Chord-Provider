//
//  FileBrowserModel.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import OSLog

/// The observable file browser state for **Chord Provider**
@Observable @MainActor class FileBrowserModel {
    /// The list of songs
    var songs: [Song] = []
    /// The list of artists
    var artists: [Artist] = []
    /// The optional songs folder
    var songsFolder: URL?
    /// The status
    var status: AppError = .unknownStatus
    /// The search query
    var search: String = ""
    /// Tab item
    var tabItem: TabItem = .artists
    /// All tags
    var allTags: [String] = []
    /// Selected tag
    var selectedTag: [String] = []

    /// Init the file browser
    init() {
        getFiles()
    }
}

extension FileBrowserModel {

    /// Get all songs from the selected folder
    func getFiles() {
        Task { @MainActor in
            if let songsFolder = UserFile.songsFolder.getBookmarkURL {
                let settings = AppSettings.load(id: .mainView)
                let content = await SongFileUtils.getSongsFromFolder(url: songsFolder, settings: settings)
                songs = content.songs
                artists = content.artists
                status = .songsFolderIsSelected
            }
        }
    }
}

extension FileBrowserModel {

    /// Tab bar items
    enum TabItem: String, CaseIterable {
        /// Artists
        case artists = "Artists"
        /// Songs
        case songs = "Songs"
        /// Tags
        case tags = "Tags"
    }
}
