//
//  FolderExport+files.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

extension FolderExport {

    /// Get all ChordPro songs from a specific folder
    /// - Returns: All found songs in a ``FileBrowser/SongItem`` array
    @MainActor static func files() throws -> [FileBrowser.SongItem] {
        var files: [FileBrowser.SongItem] = []
        /// Get a list of all files
        if let exportFolder = UserFileBookmark.getBookmarkURL(UserFileItem.exportFolder) {
            /// Get access to the URL
            _ = exportFolder.startAccessingSecurityScopedResource()
            if let items = FileManager.default.enumerator(at: exportFolder, includingPropertiesForKeys: nil) {
                while let item = items.nextObject() as? URL {
                    if ChordProDocument.fileExtension.contains(item.pathExtension) {
                        var song = FileBrowser.SongItem(fileURL: item)
                        FileBrowser.parseSongFile(item, &song)
                        files.append(song)
                    }
                }
            }
            /// Stop access to the URL
            exportFolder.stopAccessingSecurityScopedResource()
        } else {
            throw AppError.noAccessToSongError
        }
        return files.sorted(using: KeyPathComparator(\.artist)).sorted(using: KeyPathComparator(\.title))
    }
}
