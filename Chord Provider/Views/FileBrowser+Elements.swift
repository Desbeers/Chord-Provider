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
        /// The body of the `View`
        var body: some View {
            FolderBookmark.SelectFolderButton(
                bookmark: FileBrowser.folderBookmark,
                message: FileBrowser.message,
                confirmationLabel: FileBrowser.confirmationLabel,
                buttonLabel: "Select",
                buttonSystemImage: "folder"
            ) {
                fileBrowser.songsFolder = FolderBookmark.getBookmarkLink(bookmark: FileBrowser.folderBookmark)
                fileBrowser.getFiles()
            }
        }
    }
}
