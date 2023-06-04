//
//  FolderBookmark.swift
//  Chord Provider (macOS)
//
//  Created by Nick Berendsen on 04/06/2023.
//

import SwiftUI

enum FolderBookmark {
    // Just a placeholder
}

extension FolderBookmark {

    static func select(promt: String, message: String, key: String, action: @escaping () -> Void) {
        let selection = UserDefaults.standard.string(forKey: "\(key)Selection") ?? getDocumentsDirectory()
        let dialog = NSOpenPanel()
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.canChooseFiles = false
        dialog.canChooseDirectories = true
        dialog.directoryURL = URL(fileURLWithPath: selection)
        dialog.message = message
        dialog.prompt = promt
        dialog.beginSheetModal(for: NSApp.keyWindow!) { result in
            if result == NSApplication.ModalResponse.OK, let url = dialog.url {
                /// Save the url so next time this dialog is opened it will go to this folder.
                /// Sandbox stuff seems to be ok with that....
                UserDefaults.standard.set(url.path, forKey: "\(key)Selection")
                /// Create a persistent bookmark for the folder the user just selected
                _ = setPersistentFileURL(key, url)
                /// Do the closure action
                action()
            } else {
                print("Selection chanceled")
            }
        }
    }
}

extension FolderBookmark {

    /// Set the sandbox bookmark
    /// - Parameters:
    ///   - key: The name of the bookmark
    ///   - selectedURL: The URL of the bookmark
    /// - Returns: True or false if the bookmark is set
    ///
    /// Many thanks to [https://www.appcoda.com/mac-apps-user-intent/](https://www.appcoda.com/mac-apps-user-intent/)
    static func setPersistentFileURL(_ key: String, _ selectedURL: URL) -> Bool {
        do {
            let bookmarkData = try selectedURL.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
            UserDefaults.standard.set(bookmarkData, forKey: key)
            return true
        } catch let error {
            print("Could not create a bookmark because: ", error)
            return false
        }
    }
}

extension FolderBookmark {

    /// Get the sandbox bookmark
    /// - Parameter key: The name of the bookmark
    /// - Returns: The URL of the bookmark
    static func getPersistentFileURL(_ key: String) -> URL? {
        if let bookmarkData = UserDefaults.standard.data(forKey: key) {
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
                    _ = setPersistentFileURL(key, urlForBookmark)
                    return nil

                } else {
                    return urlForBookmark
                }
            } catch {
                print("Error resolving bookmark:", error)
                return nil
            }
        } else {
            print("Error retrieving persistent bookmark data.")
            return nil
        }
    }
}

extension FolderBookmark {

    /// Get the Documents directory
    /// - Returns: The users Documents directory
    ///
    /// Used when no folders are selected by the user.
    static func getDocumentsDirectory() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    }
}

extension FolderBookmark {

    /// Open a folder in the Finder
    static func openInFinder(url: URL?) {
        guard let url = url else {
            print("Not a valid URL")
            return
        }
        NSWorkspace.shared.activateFileViewerSelecting([url])
    }
}
