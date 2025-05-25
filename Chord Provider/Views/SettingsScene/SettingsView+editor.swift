//
//  SettingsView+editor.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension SettingsView {

    /// `View` with editor settings
    @ViewBuilder var `editor`: some View {
        @Bindable var appState = appState
        VStack {
            ScrollView {
                VStack {
                    VStack(alignment: .leading) {
                        Toggle("Use a custom template for a new song", isOn: $appState.settings.application.useCustomSongTemplate)
                    }
                    UserFileButton(
                        userFile: UserFileUtils.Selection.customSongTemplate
                    ) {}
                        .disabled(!appState.settings.application.useCustomSongTemplate)
                    Text("You can use your own **ChordPro** file as a starting point when you create a new song")
                        .font(.caption)
                }
                .wrapSettingsSection(title: "Song Template")
                VStack {
                    SizeSlider(
                        fontSize: $appState.settings.editor.fontSize,
                        range: Editor.Settings.fontSizeRange,
                        label: .symbol
                    )
                }
                .wrapSettingsSection(title: "Editor Font")
                VStack {
                    ColorPickerButton(
                        selectedColor: $appState.settings.editor.chordColor,
                        label: "Color for **chords**"
                    )
                    ColorPickerButton(
                        selectedColor: $appState.settings.editor.directiveColor,
                        label: "Color for **directives**"
                    )
                    ColorPickerButton(
                        selectedColor: $appState.settings.editor.argumentColor,
                        label: "Color for **arguments**"
                    )
                    ColorPickerButton(
                        selectedColor: $appState.settings.editor.markupColor,
                        label: "Color for **markup**"
                    )
                    ColorPickerButton(
                        selectedColor: $appState.settings.editor.bracketColor,
                        label: "Color for **brackets**"
                    )
                    ColorPickerButton(
                        selectedColor: $appState.settings.editor.commentColor,
                        label: "Color for **comments**"
                    )
                }
                .wrapSettingsSection(title: "Highlight Colors")
            }
            .frame(maxHeight: .infinity, alignment: .top)
            Button(
                action: {
                    appState.settings.editor = Editor.Settings()
                },
                label: {
                    Text("Reset to defaults")
                }
            )
            .padding(.bottom)
            .disabled(appState.settings.editor == Editor.Settings())
        }
    }
}
