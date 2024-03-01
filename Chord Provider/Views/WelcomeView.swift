//
//  WelcomeView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for the welcome screen
struct WelcomeView: View {
    @State private var fileBrowser: FileBrowser = .shared
    var body: some View {
        VStack {
            Text("Welcome to Chord Provider")
                .font(.title)
            Image(.launchIcon)
                .resizable()
                .scaledToFit()
            VStack(alignment: .leading) {
                Text(.init(AudioStatus.help))
                    .padding(.bottom)
#if os(macOS)
                Text(.init(AudioStatus.browser))
#endif
            }
            .frame(maxWidth: 500)
            fileBrowser.folderSelector
                .buttonStyle(.bordered)
        }
        .padding()
    }
}
