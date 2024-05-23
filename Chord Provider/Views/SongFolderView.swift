//
//  SongFolderView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for selecting the songs folder
struct SongFolderView: View {
    /// The observable ``FileBrowser`` class
    @Environment(FileBrowser.self) private var fileBrowser
    var body: some View {
        VStack {
            Image(.launchIcon)
                .resizable()
                .scaledToFit()
            VStack(alignment: .leading) {
                Text(.init(Help.folderSelector))
                    .padding(.bottom)
            }
            .frame(maxWidth: 500)
            fileBrowser.folderSelector
                .buttonStyle(.bordered)
        }
    }
}
