//
//  UserFileUtils+bookmark.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

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
            Task {
                await LogUtils.shared.log(
                    .init(
                        type: .error,
                        category: .application,
                        message: error.localizedDescription
                    )
                )
            }
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
        } catch let error {
            Task {
                await LogUtils.shared.log(
                    .init(
                        type: .error,
                        category: .application,
                        message: "Bookmark error: '\(error.localizedDescription)'"
                    )
                )
            }
            selectedURL.stopAccessingSecurityScopedResource()
        }
    }
}
