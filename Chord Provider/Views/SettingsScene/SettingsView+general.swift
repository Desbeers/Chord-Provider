//
//  SettingsView+general.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension SettingsView {

    /// `View` with general options
    @ViewBuilder var general: some View {
        @Bindable var appState = appState
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    Toggle("Use a custom template for a new song", isOn: $appState.settings.application.useCustomSongTemplate)
                }
                UserFileButton(
                    userFile: UserFile.customSongTemplate
                ) {}
                    .disabled(!appState.settings.application.useCustomSongTemplate)
                Text("You can use your own **ChordPro** file as a starting point when you create a new song")
                    .font(.caption)
            }
            .wrapSettingsSection(title: "General Options")
            VStack {
                VStack(alignment: .leading) {
                    Toggle(isOn: $appState.settings.chordPro.useChordProCLI) {
                        Text("Use the official ChordPro to create a PDF")
                        Text("When enabled, PDF's will be rendered with the official ChordPro reference implementation.")
                    }
                    Toggle(isOn: $appState.settings.chordPro.useCustomConfig) {
                        Text("Use a custom ChordPro configuration")
                        Text("When enabled, ChordPro will use your own configuration.")
                    }
                    .disabled(!appState.settings.chordPro.useChordProCLI)
                }
                UserFileButton(
                    userFile: UserFile.customChordProConfig
                ) {}
                    .disabled(!appState.settings.chordPro.useChordProCLI || !appState.settings.chordPro.useCustomConfig)
                VStack(alignment: .leading) {
                    Toggle(isOn: $appState.settings.chordPro.useAdditionalLibrary) {
                        Text("Add a custom library")
                        // swiftlint:disable:next line_length
                        Text("**ChordPro** has a built-in library with configs and other data. With *custom library* you can add an additional location where to look for data.")
                    }
                    .disabled(!appState.settings.chordPro.useChordProCLI)
                }
                UserFileButton(
                    userFile: UserFile.customChordProLibrary
                ) {}
                    .disabled(!appState.settings.chordPro.useChordProCLI || !appState.settings.chordPro.useAdditionalLibrary)
            }
            .wrapSettingsSection(title: "ChordPro CLI Integration")
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}
