//
//  FileBrowserModel+Elements.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
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
                userFile: UserFile.songsFolder
            ) {
                Task {
                    fileBrowser.songsFolder = UserFile.songsFolder.getBookmarkURL
                }
            }
        }
    }
}
