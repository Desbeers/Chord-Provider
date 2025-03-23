//
//  SettingsView+pdf.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension SettingsView {

    /// `View` with PDF settings
    @ViewBuilder var pdf: some View {
        @Bindable var appState = appState
        VStack {
            VStack {
                ScrollView {
                    VStack {
                        HStack {
                            Button("Light") {
                                appState.settings.pdf = AppSettings.PDF.Preset.light.presets(settings: appState.settings.pdf)
                            }
                            .disabled(appState.settings.pdf == AppSettings.PDF.Preset.light.presets(settings: appState.settings.pdf))
                            Button("Dark") {
                                appState.settings.pdf = AppSettings.PDF.Preset.dark.presets(settings: appState.settings.pdf)
                            }
                            .disabled(appState.settings.pdf == AppSettings.PDF.Preset.dark.presets(settings: appState.settings.pdf))
                            Button("Random") {
                                appState.settings.pdf = AppSettings.PDF.Preset.random.presets(settings: appState.settings.pdf)
                            }
                        }
                    }
                    .wrapSettingsSection(title: "Color Templates")
                    VStack {
                        Form {
                            ColorPicker("Foreground Color", selection: $appState.settings.pdf.theme.foreground, supportsOpacity: false)
                            ColorPicker("Secondary Foreground Color", selection: $appState.settings.pdf.theme.foregroundMedium, supportsOpacity: false)
                            ColorPicker("Background Color", selection: $appState.settings.pdf.theme.background, supportsOpacity: false)
                        }
                        .formStyle(.columns)
                    }
                    .wrapSettingsSection(title: "General")
                    FontOptionsView(settings: $appState.settings.pdf)
                }
            }
            .frame(maxWidth: .infinity, alignment: .top)
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
                        jsonExportString = appState.settings.pdf.exportToJSON
                        showJsonExportDialog = true
                    },
                    label: {
                        Text("Export Theme")
                    }
                )
            }
            Button(
                action: {
                    appState.settings.pdf = AppSettings.PDF()
                },
                label: {
                    Text("Reset to defaults")
                }
            )
            .padding(.bottom)
            .disabled(appState.settings.pdf == AppSettings.PDF())
        }
    }
}
