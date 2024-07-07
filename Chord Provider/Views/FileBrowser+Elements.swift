//
//  FileBrowser+Elements.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import ChordProShared

extension FileBrowser {

    // MARK: Folder Selector

    /// Folder Selector
    var folderSelector: some View {
        FolderSelector(fileBrowser: self)
            .id(self.songsFolder)
    }
    /// Folder Selector
    private struct FolderSelector: View {
        /// The FileBrowser model
        @Bindable var fileBrowser: FileBrowser
        /// The body of the `View`
        var body: some View {
            UserFileButtonView(
                userFile: UserFileItem.songsFolder
            ) {
                fileBrowser.songsFolder = try? UserFileBookmark.getBookmarkURL(UserFileItem.songsFolder)
            }
        }
    }
}
