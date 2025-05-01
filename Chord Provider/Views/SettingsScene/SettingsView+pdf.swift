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
        ScrollView {
            Form {
                LabeledContent("Page Size") {
                    Picker("Page Size", selection: $appState.settings.pdf.pageSize) {
                        ForEach(PDFBuild.PageSize.allCases, id: \.self) { page in
                            Text(page.rawValue)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.radioGroup)
                }
                if appState.settings.pdf.pageSize == .custom {
                    LabeledContent("Custom Size") {
                        VStack {
                            SizeSlider(fontSize: $appState.settings.pdf.customWidth, range: 200...2000, label: .number)
                            SizeSlider(fontSize: $appState.settings.pdf.customHeight, range: 200...2000, label: .number)
                            Text("The size will be \(Int(appState.settings.pdf.customWidth)) by \(Int(appState.settings.pdf.customHeight)) points")
                                .font(.caption)
                        }
                    }
                }
                Divider()
                LabeledContent("Page Padding") {
                    VStack {
                        SizeSlider(fontSize: $appState.settings.pdf.pagePadding, range: 10...100, label: .number)
                        Text("The padding of the content will be \(Int(appState.settings.pdf.pagePadding)) points")
                            .font(.caption)
                    }
                }
                LabeledContent("Diagram Width") {
                    VStack {
                        SizeSlider(fontSize: $appState.settings.pdf.diagramWidth, range: 20...120, label: .symbol)
                        Text("The diagram will be \(Int(appState.settings.pdf.diagramWidth)) points wide")
                            .font(.caption)
                    }
                }
                Toggle(isOn: $appState.settings.pdf.centerContent) {
                    Text("Center main content")
                    Text("When enabled, the main content will be centred based on the longest lyrics line.")
                }
                Toggle(isOn: $appState.settings.pdf.showTags) {
                    Text("Show tags")
                    Text("When enabled, the optional tags will be added to the PDF.")
                }
                Toggle(isOn: $appState.settings.pdf.scaleFonts) {
                    Text("Scale fonts")
                    Text("When enabled, fonts will be scaled if content does not fit.")
                }
            }
            .wrapSettingsSection(title: "PDF Options")
            VStack(alignment: .leading) {
                Toggle(isOn: $appState.settings.chordPro.useChordProCLI) {
                    Text("Use the official ChordPro to create a PDF")
                    Text("When enabled, PDF's will be rendered with the official ChordPro reference implementation.")
                }
                if appState.settings.chordPro.useChordProCLI {
                    Toggle(isOn: $appState.settings.chordPro.useChordProviderSettings) {
                        Text("Use the **Chord Provider** settings")
                        Text("When enabled, some style and options from the settings will be used by the CLI.")
                    }
                    Toggle(isOn: $appState.settings.chordPro.useCustomConfig) {
                        Text("Use a custom ChordPro configuration")
                        Text("When enabled, ChordPro will use your own configuration.")
                    }
                    .disabled(!appState.settings.chordPro.useChordProCLI)
                    UserFileButton(
                        userFile: UserFile.customChordProConfig
                    ) {}
                        .frame(maxWidth: .infinity)
                        .disabled(!appState.settings.chordPro.useCustomConfig)
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
                        .frame(maxWidth: .infinity)
                        .disabled(!appState.settings.chordPro.useAdditionalLibrary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .wrapSettingsSection(title: "ChordPro CLI Integration")
        }
        .animation(.default, value: appState.settings.pdf.pageSize)
        .animation(.default, value: appState.settings.chordPro.useChordProCLI)
        .formStyle(.columns)
        .frame(maxHeight: .infinity, alignment: .top)
        Button(
            action: {
                appState.settings.pdf = AppSettings.PDF()
                appState.settings.chordPro.useChordProCLI = false
            },
            label: {
                Text("Reset to defaults")
            }
        )
        .padding(.bottom)
        .disabled(appState.settings.pdf == AppSettings.PDF() && appState.settings.chordPro.useChordProCLI == false)
    }
}
