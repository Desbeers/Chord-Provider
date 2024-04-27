//
//  SongFolderView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for selecting the songs folder
struct SongFolderView: View {
    /// The FileBrowser model
    @Environment(FileBrowser.self) private var fileBrowser
    var body: some View {
        VStack {
            Image(.launchIcon)
                .resizable()
                .scaledToFit()
            VStack(alignment: .leading) {
                Text(.init(AudioFileStatus.help))
                    .padding(.bottom)
            }
            .frame(maxWidth: 500)
            fileBrowser.folderSelector
                .buttonStyle(.bordered)
        }
    }
}
