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
                    FontSizeSlider(
                        fontSize: $appState.settings.editor.fontSize,
                        range: Editor.Settings.fontSizeRange,
                        label: .symbol
                    )
                    FontStylePicker(style: $appState.settings.editor.fontStyle)
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
