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
                    Form {
                        LabeledContent("Fonts:") {
                            VStack {
                                HStack {
                                    ForEach(AppSettings.Style.FontPreset.allCases, id: \.self) { preset in
                                        Button(preset.rawValue) {
                                            appState.settings.style = preset.presets(style: appState.settings.style, fonts: appState.fonts)
                                        }
                                        .disabled(appState.settings.style == preset.presets(style: appState.settings.style, fonts: appState.fonts))
                                    }
                                }
                                Text("**Random** just picks fonts from your catalog;\nit may or may not look good.")
                                    .font(.caption)
                            }
                        }
                        LabeledContent("Colors:") {
                            VStack {
                                HStack {
                                    ForEach(AppSettings.Style.ColorPreset.allCases, id: \.self) { preset in
                                        Button(preset.rawValue) {
                                            appState.settings.style = preset.presets(style: appState.settings.style)
                                        }
                                        .disabled(appState.settings.style == preset.presets(style: appState.settings.style))
                                    }
                                }
                                Text("**Random** just gives you some inspirations;\nit might look awful.")
                                    .font(.caption)
                            }
                        }
                    }
                    .wrapSettingsSection(title: "Templates")
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
                    appState.settings.style = appState.settings.style.defaults()
                },
                label: {
                    Text("Reset to defaults")
                }
            )
            .padding(.bottom)
            .disabled(appState.settings.style == appState.settings.style.defaults())
        }
    }
}
