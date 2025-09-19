//
//  FolderExport+files.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension FolderExport {

    /// Get all ChordPro songs from a specific folder
    /// - Returns: All found songs in a ``ChordProviderCore/Song`` array
    @MainActor static func files() async throws -> [Song] {
        /// Get a list of all files
        if let exportFolder = UserFileUtils.Selection.exportFolder.getBookmarkURL {
            let settings = AppSettings.load(id: .exportFolderView)
            let content = await SongFileUtils.getSongsFromFolder(
                url: exportFolder,
                settings: settings
            )
            return content.songs
        } else {
            throw AppError.noAccessToSongError
        }
    }
}
