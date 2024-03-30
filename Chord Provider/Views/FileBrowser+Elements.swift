//
//  FileBrowser+Elements.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 29/02/2024.
//

import SwiftUI
import SwiftlyFolderUtilities

extension FileBrowser {

    // MARK: Folder Selector

    var folderSelector: some View {
        FolderSelector(fileBrowser: self)
    }

    private struct FolderSelector: View {
        /// The FileBrowser model
        @Bindable var fileBrowser: FileBrowser
        /// The current selected folder
        @State private var currentFolder: String = FileBrowser.folderTitle
        var body: some View {
            FolderBookmark.SelectFolderButton(
                bookmark: FileBrowser.bookmark,
                message: FileBrowser.message,
                confirmationLabel: FileBrowser.confirmationLabel,
                buttonLabel: currentFolder,
                buttonSystemImage: "folder"
            ) {
                currentFolder = FileBrowser.folderTitle
                fileBrowser.getFiles()
            }
        }
    }

    /// Get the current selected folder
    private static var folderTitle: String {
        FolderBookmark.getBookmarkLink(bookmark: FileBrowser.bookmark)?.lastPathComponent ?? "No folder selected"
    }
}
