//
//  FileBrowserModel+Elements.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

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
                userFile: UserFileUtils.Selection.songsFolder
            ) {
                Task {
                    fileBrowser.songsFolder = UserFileUtils.Selection.songsFolder.getBookmarkURL
                }
            }
        }
    }
}
