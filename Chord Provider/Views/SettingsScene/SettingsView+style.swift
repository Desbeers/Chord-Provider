//
//  SettingsView+style.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import OSLog

extension SettingsView {

    /// `View` with style settings
    @ViewBuilder var style: some View {
        @Bindable var appState = appState
        VStack(spacing: 0) {
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
                        LabeledContent("Templates:") {
                            Menu("Select a template") {
                                ForEach(Samples.theme, id: \.self) { theme in
                                    Button(theme.rawValue) {
                                        if let themeURL = Bundle.main.url(forResource: theme.rawValue, withExtension: "json") {
                                            do {
                                                let text = try Data(contentsOf: themeURL)
                                                let style = try JSONDecoder().decode(AppSettings.Style.self, from: text)
                                                appState.settings.style = style
                                            } catch {
                                                Logger.fileAccess.error("Theme import failed: \(error.localizedDescription, privacy: .public)")
                                            }
                                        }
                                    }
                                }
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
                        .padding(.bottom)
                }
            }
            .frame(maxWidth: .infinity, alignment: .top)
            .animation(.default, value: appState.settings.style)
            Divider()
            VStack {
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
            }
            .padding()
            .disabled(appState.settings.style == appState.settings.style.defaults())
        }
        .fileExporter(
            isPresented: $showJsonExportDialog,
            document: JSONDocument(string: jsonExportString),
            contentTypes: [.json],
            defaultFilename: "Theme"
        ) { result in
            switch result {
            case .success(let url):
                Logger.fileAccess.info("Theme exported to \(url, privacy: .public)")
            case .failure(let error):
                Logger.fileAccess.error("Export failed: \(error.localizedDescription, privacy: .public)")
            }
        }
        .fileImporter(
            isPresented: $showJsonImportDialog,
            allowedContentTypes: [.json],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let files):
                do {
                    try files.forEach { url in
                        let text = try Data(contentsOf: url)
                        appState.settings.style = try JSONDecoder().decode(AppSettings.Style.self, from: text)
                        Logger.fileAccess.info("Theme imported from \(url, privacy: .public)")
                    }
                } catch {
                    Logger.fileAccess.error("Import failed: \(error.localizedDescription, privacy: .public)")
                    errorAlert = AppError.importThemeError.alert()
                }
            case .failure(let error):
                Logger.fileAccess.error("Import failed: \(error.localizedDescription, privacy: .public)")
                errorAlert = AppError.importThemeError.alert()
            }
        }
    }
}
