//
//  FolderExport+files.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog
import SwiftlyFolderUtilities

extension FolderExport {

    /// Get all ChordPro songs from a specific folder
    /// - Returns: All found songs in a ``FileBrowser/SongItem`` array
    static func files() throws -> [FileBrowser.SongItem] {
        var files: [FileBrowser.SongItem] = []
        do {
            /// Get a list of all files
            try FolderBookmark.action(bookmark: FileBrowser.exportBookmark) { persistentURL in
                if let items = FileManager.default.enumerator(at: persistentURL, includingPropertiesForKeys: nil) {
                    while let item = items.nextObject() as? URL {
                        if ChordProDocument.fileExtension.contains(item.pathExtension) {
                            var song = FileBrowser.SongItem(fileURL: item)
                            FileBrowser.parseSongFile(item, &song)
                            files.append(song)
                        }
                    }
                }
            }
        } catch {
            throw ChordProviderError.noAccessToSongError
        }
        return files.sorted(using: KeyPathComparator(\.artist)).sorted(using: KeyPathComparator(\.title))
    }
}
