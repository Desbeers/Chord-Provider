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
                Task {
                    fileBrowser.songsFolder = UserFileBookmark.getBookmarkURL(UserFileItem.songsFolder)
                }
            }
        }
    }
}
