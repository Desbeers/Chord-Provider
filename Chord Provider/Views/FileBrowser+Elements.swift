//
//  FileBrowser+Elements.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

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
            FileButtonView(
                bookmark: .songsFolder
            ) {
                fileBrowser.songsFolder = try? FileBookmark.getBookmarkURL(.songsFolder)
            }
        }
    }
}
