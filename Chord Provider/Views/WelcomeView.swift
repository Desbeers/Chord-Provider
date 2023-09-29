//
//  WelcomeView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for the welcome screen
struct WelcomeView: View {

    var body: some View {
        VStack {
            Text("Welcome to Chord Provider")
                .font(.title)
            Image(.launchIcon)
                .resizable()
                .scaledToFit()
            VStack(alignment: .leading) {
                Text(.init(Status.help))
                    .padding(.bottom)
#if os(macOS)
                Text(.init(Status.browser))
#endif
            }
            .frame(maxWidth: 500)
            ToolbarView.FolderSelector()
                .buttonStyle(.bordered)
        }
        .padding()
    }
}
