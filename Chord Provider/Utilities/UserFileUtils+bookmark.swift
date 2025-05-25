//
//  UserFileUtils+bookmark.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation
import OSLog

extension UserFileUtils.Selection {

    /// Get an optional bookmark URL
    /// - Parameter bookmark: The ``UserFileUtils/Selection``
    /// - Returns: An URL if found
    var getBookmarkURL: URL? {
        guard let bookmarkData = UserDefaults.standard.data(forKey: self.id) else {
            return nil
        }
        do {
            var bookmarkDataIsStale = false
            let urlForBookmark = try URL(
                resolvingBookmarkData: bookmarkData,
                relativeTo: nil,
                bookmarkDataIsStale: &bookmarkDataIsStale
            )
            if bookmarkDataIsStale {
                setBookmarkURL(urlForBookmark)
            }
            return urlForBookmark
        } catch {
            Logger.fileAccess.error("\(error.localizedDescription, privacy: .public)")
            return nil
        }
    }

    /// Set an bookmark URL
    /// - Parameter selectedURL: The URL to set
    func setBookmarkURL( _ selectedURL: URL) {
        do {
            _ = selectedURL.startAccessingSecurityScopedResource()
            let bookmarkData = try selectedURL.bookmarkData(
                includingResourceValuesForKeys: nil,
                relativeTo: nil
            )
            UserDefaults.standard.set(bookmarkData, forKey: self.id)
            selectedURL.stopAccessingSecurityScopedResource()
            Logger.fileAccess.info("Bookmark set for '\(selectedURL.lastPathComponent, privacy: .public)'")
        } catch let error {
            Logger.fileAccess.error("Bookmark error: '\(error.localizedDescription, privacy: .public)'")
            selectedURL.stopAccessingSecurityScopedResource()
        }
    }
}
