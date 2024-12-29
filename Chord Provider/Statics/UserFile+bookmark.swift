//
//  UserFile+bookmark.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation
import OSLog

extension UserFile {

    /// Get an optional bookmark URL
    /// - Parameter bookmark: The ``UserFile``
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
    /// - Parameters:
    ///   - bookmark: The ``UserFile``
    ///   - selectedURL: The URL to set
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

    /// Stop access to a persistent URL after some time
    /// - Note: Always call this function after you are done with the access or else Apple will be really upset!
    func stopCustomFileAccess() {
        if let persistentURL = self.getBookmarkURL {
            Task {
                try? await Task.sleep(nanoseconds: 500_000_000_000)
                persistentURL.stopAccessingSecurityScopedResource()
                Logger.fileAccess.info("Stopped access to '\(persistentURL.lastPathComponent, privacy: .public)'")
            }
        } else {
            Logger.fileAccess.error("Access error '\(self.rawValue, privacy: .public)'")
        }
    }
}
