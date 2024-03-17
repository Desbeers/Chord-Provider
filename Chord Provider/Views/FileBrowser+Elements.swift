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
        @Bindable var fileBrowser: FileBrowser
        /// Folder selector title
        private var folderTitle: String {
            FolderBookmark.getBookmarkLink(bookmark: FileBrowser.bookmark)?.lastPathComponent ?? "No folder selected"
        }
        var body: some View {
            FolderBookmark.SelectFolderButton(
                bookmark: FileBrowser.bookmark,
                message: FileBrowser.message,
                confirmationLabel: FileBrowser.confirmationLabel,
                buttonLabel: folderTitle,
                buttonSystemImage: "folder"
            ) {
                Task { @MainActor in
                    await fileBrowser.getFiles()
                }
            }
        }
    }
}
