//
//  FileBrowser+Elements.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import SwiftlyFolderUtilities

extension FileBrowser {

    // MARK: Folder Selector

    /// Folder Selector
    var folderSelector: some View {
        FolderSelector(fileBrowser: self)
    }
    /// Folder Selector
    private struct FolderSelector: View {
        /// The FileBrowser model
        @Bindable var fileBrowser: FileBrowser
        /// The current selected folder
        @State private var currentFolder: String = FileBrowser.folderTitle
        var body: some View {
            FolderBookmark.SelectFolderButton(
                bookmark: FileBrowser.folderBookmark,
                message: FileBrowser.message,
                confirmationLabel: FileBrowser.confirmationLabel,
                buttonLabel: currentFolder,
                buttonSystemImage: "folder"
            ) {
                fileBrowser.songsFolder = FolderBookmark.getBookmarkLink(bookmark: FileBrowser.folderBookmark)
                currentFolder = FileBrowser.folderTitle
                fileBrowser.getFiles()
            }
        }
    }

    /// Get the current selected folder
    private static var folderTitle: String {
        FolderBookmark.getBookmarkLink(bookmark: FileBrowser.folderBookmark)?.lastPathComponent ?? "No folder selected"
    }
}
