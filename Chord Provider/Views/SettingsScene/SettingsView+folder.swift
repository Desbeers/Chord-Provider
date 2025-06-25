//
//  SettingsView+folder.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension SettingsView {

    /// `View` with folder selector
    @ViewBuilder var folder: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack {
                    TextField("List of articles to ignore", text: $sortTokens, prompt: Text("the,a,de,een"))
                    Text("Comma separated list of articles to ignore when sorting songs and artists. Case insensitive.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .wrapSettingsSection(title: "Sort songs and artists")
                .task {
                    sortTokens = appState.settings.application.sortTokens.joined(separator: ",")
                }
                .onChange(of: sortTokens) {
                    appState.settings.application.sortTokens = sortTokens.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                }
                VStack {
                    Text(.init(Help.fileBrowser))
                        .padding()
                    fileBrowser.folderSelector
                        .padding()
                }
                .wrapSettingsSection(title: "The folder with your songs")
                .padding(.bottom)
            }
        }
        .padding(.bottom)
        .frame(maxWidth: .infinity)
    }
}
