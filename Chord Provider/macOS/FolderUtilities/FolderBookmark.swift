//
//  FolderBookmark.swift
//  Chord Provider (macOS)
//
//  Created by Nick Berendsen on 04/06/2023.
//
// Many thanks to https://www.appcoda.com/mac-apps-user-intent/

import SwiftUI

/// Functions to work with persistent selected folders
enum FolderBookmark {
    // Just a placeholder
}

extension FolderBookmark {

    /// Open a sheet to select a folder
    /// - Parameters:
    ///   - promt: The text for the default button
    ///   - message: The message in the dialog
    ///   - bookmark: The name of the bookmark
    ///   - action: The action after the folder is selected
    static func select(promt: String, message: String, bookmark: String, action: @escaping () -> Void) {
        let selection = getPersistentFileURL(bookmark) ?? getDocumentsDirectory()
        let dialog = NSOpenPanel()
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.canChooseFiles = false
        dialog.canChooseDirectories = true
        dialog.directoryURL = selection
        dialog.message = message
        dialog.prompt = promt
        dialog.canCreateDirectories = true
        dialog.beginSheetModal(for: NSApp.keyWindow!) { result in
            guard  result == .OK, let url = dialog.url else {
                return
            }
            /// Create a persistent bookmark for the folder the user just selected
            _ = setPersistentFileURL(bookmark, url)
            /// Do the closure action
            action()
        }
    }
}

extension FolderBookmark {

    /// Perform an action with a bookmark folder
    /// - Parameters:
    ///   - bookmark: The name of the bookmark
    ///   - action: The action for the bookmark folder
    static func action(bookmark: String, action: (_ url: URL) async -> Void) async {
        guard let persistentURL = FolderBookmark.getPersistentFileURL(bookmark) else {
            return
        }
        /// Make sure the security-scoped resource is released when finished
        defer {
            persistentURL.stopAccessingSecurityScopedResource()
        }
        /// Start accessing a security-scoped resource
        _ = persistentURL.startAccessingSecurityScopedResource()
        await action(persistentURL)
    }
}

extension FolderBookmark {

    /// Open an URL in the Finder
    /// - Parameter url: The URL to open
    static func openInFinder(url: URL?) {
        guard let url = url else {
            return
        }
        NSWorkspace.shared.activateFileViewerSelecting([url])
    }
}

private extension FolderBookmark {

    /// Set the sandbox bookmark
    /// - Parameters:
    ///   - bookmark: The name of the bookmark
    ///   - selectedURL: The URL of the bookmark
    /// - Returns: True or false if the bookmark is set
    static func setPersistentFileURL(_ bookmark: String, _ selectedURL: URL) -> Bool {
        do {
            let bookmarkData = try selectedURL.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
            UserDefaults.standard.set(bookmarkData, forKey: bookmark)
            return true
        } catch let error {
            print("Could not create a bookmark because: ", error)
            return false
        }
    }
}

private extension FolderBookmark {

    /// Get the sandbox bookmark
    /// - Parameter bookmark: The name of the bookmark
    /// - Returns: The URL of the bookmark
    static func getPersistentFileURL(_ bookmark: String) -> URL? {
        guard let bookmarkData = UserDefaults.standard.data(forKey: bookmark) else {
            print("Error retrieving persistent bookmark data.")
            return nil
        }
        do {
            var bookmarkDataIsStale = false
            let urlForBookmark = try URL(
                resolvingBookmarkData: bookmarkData,
                options: .withSecurityScope,
                relativeTo: nil,
                bookmarkDataIsStale: &bookmarkDataIsStale
            )
            if bookmarkDataIsStale {
                print("The bookmark is outdated and needs to be regenerated.")
                _ = setPersistentFileURL(bookmark, urlForBookmark)
            }
            return urlForBookmark
        } catch {
            print("Error resolving bookmark:", error)
            return nil
        }
    }
}

private extension FolderBookmark {

    /// Get the Documents directory
    /// - Returns: The users Documents directory
    static func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}
