//
//  SettingsView+style.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension SettingsView {

    /// `View` with style settings
    @ViewBuilder var style: some View {
        @Bindable var appState = appState
        VStack {
            VStack {
                ScrollView {
                    VStack {
                        HStack {
                            ForEach(AppSettings.Style.ColorPreset.allCases, id: \.self) { preset in
                                Button(preset.rawValue) {
                                    appState.settings.style = preset.presets(style: appState.settings.style)
                                }
                                .disabled(appState.settings.style == preset.presets(style: appState.settings.style))
                            }
                        }
                    }
                    .wrapSettingsSection(title: "Color Templates")
                    VStack {
                        Form {
                            ColorPicker("Foreground Color", selection: $appState.settings.style.theme.foreground, supportsOpacity: true)
                            ColorPicker("Medium Foreground Color", selection: $appState.settings.style.theme.foregroundMedium, supportsOpacity: true)
                            ColorPicker("Light Foreground Color", selection: $appState.settings.style.theme.foregroundLight, supportsOpacity: true)
                            ColorPicker("Background Color", selection: $appState.settings.style.theme.background, supportsOpacity: false)
                        }
                        .formStyle(.columns)
                    }
                    .wrapSettingsSection(title: "General")
                    FontOptionsView(settings: $appState.settings)
                }
            }
            .frame(maxWidth: .infinity, alignment: .top)
            .animation(.default, value: appState.settings.style)
            HStack {
                Button(
                    action: {
                        showJsonImportDialog = true
                    },
                    label: {
                        Text("Import Theme")
                    }
                )
                Button(
                    action: {
                        jsonExportString = appState.settings.style.exportToJSON
                        showJsonExportDialog = true
                    },
                    label: {
                        Text("Export Theme")
                    }
                )
            }
            Button(
                action: {
                    appState.settings.style = AppSettings.Style()
                },
                label: {
                    Text("Reset to defaults")
                }
            )
            .padding(.bottom)
            .disabled(appState.settings.style == AppSettings.Style())
        }
    }
}
