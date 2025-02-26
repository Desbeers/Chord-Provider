//
//  FolderExport+files.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation
import OSLog

extension FolderExport {

    /// Get all ChordPro songs from a specific folder
    /// - Returns: All found songs in a ``FileBrowserModel/SongItem`` array
    @MainActor static func files() throws -> [FileBrowserModel.SongItem] {
        var files: [FileBrowserModel.SongItem] = []
        /// Get a list of all files
        if let exportFolder = UserFile.exportFolder.getBookmarkURL {
            /// Get access to the URL
            _ = exportFolder.startAccessingSecurityScopedResource()
            if let items = FileManager.default.enumerator(at: exportFolder, includingPropertiesForKeys: nil) {
                while let item = items.nextObject() as? URL {
                    if ChordProDocument.fileExtension.contains(item.pathExtension) {
                        var song = FileBrowserModel.SongItem(fileURL: item)
                        FileBrowserModel.parseSongFile(item, &song)
                        files.append(song)
                        dump(song.sortArtist)
                    }
                }
            }
            /// Stop access to the URL
            exportFolder.stopAccessingSecurityScopedResource()
        } else {
            throw AppError.noAccessToSongError
        }
        return files.sorted(using: KeyPathComparator(\.sortArtist)).sorted(using: KeyPathComparator(\.title))
    }
}
