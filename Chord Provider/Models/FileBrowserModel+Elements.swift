//
//  FileBrowserModel+Elements.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import OSLog

extension FileBrowserModel {

    // MARK: Folder Selector

    /// Folder Selector
    var folderSelector: some View {
        FolderSelector(fileBrowser: self)
            .id(self.songsFolder)
    }
    /// Folder Selector
    private struct FolderSelector: View {
        /// The FileBrowser model
        @Bindable var fileBrowser: FileBrowserModel
        /// The body of the `View`
        var body: some View {
            UserFileButton(
                userFile: UserFileItem.songsFolder
            ) {
                fileBrowser.songsFolder = UserFileBookmark.getBookmarkURL(UserFileItem.songsFolder)
            }
        }
    }

    // MARK: Open Song URL

    @MainActor func openSong(url: URL) async {
        /// SwiftUI openDocument is very buggy; don't try to open a document when it is already open; the app will crash..
        /// So I use the shared NSDocumentController instead
        if let persistentURL = UserFileBookmark.getBookmarkURL(UserFileItem.songsFolder) {
            _ = persistentURL.startAccessingSecurityScopedResource()
            do {
                try await NSDocumentController.shared.openDocument(withContentsOf: url, display: true)
            } catch {
                Logger.application.error("Error opening URL: \(error.localizedDescription, privacy: .public)")
            }
            persistentURL.stopAccessingSecurityScopedResource()
        }
        /// If the browser is shown in a MenuBarExtra, close it
        menuBarExtraWindow?.close()
    }
}
