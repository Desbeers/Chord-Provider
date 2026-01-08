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
        VStack(spacing: 0) {
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
            }
            .animation(.default, value: appState.settings.pdf.pageSize)
            .formStyle(.columns)
            .frame(maxHeight: .infinity, alignment: .top)
            Divider()
            Button(
                action: {
                    appState.settings.pdf = AppSettings.PDF()
                },
                label: {
                    Text("Reset to defaults")
                }
            )
            .padding()
            .disabled(appState.settings.pdf == AppSettings.PDF())
        }
    }
}
