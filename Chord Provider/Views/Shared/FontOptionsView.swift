//
//  FontOptionsView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

struct FontOptionsView: View {
    @Binding var settings: AppSettings.PDF
    var body: some View {
        ForEach(ChordPro.FontConfig.allCases, id: \.self) { config in
            VStack {
                switch config {
                case .title:
                    Options(settings: settings, config: config, options: $settings.fonts.title)
                case .subtitle:
                    Options(settings: settings, config: config, options: $settings.fonts.subtitle)
                case .text:
                    Options(settings: settings, config: config, options: $settings.fonts.text)
                case .chord:
                    Options(settings: settings, config: config, options: $settings.fonts.chord)
                case .label:
                    Options(settings: settings, config: config, options: $settings.fonts.label)
                case .comment:
                    Options(settings: settings, config: config, options: $settings.fonts.comment)
                }
                if let help = config.help {
                    LabeledContent {
                        Text(.init(help))
                    } label: {
                        Image(systemName: "info.circle")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .wrapSettingsSection(title: config.rawValue)
        }
    }
}

extension FontOptionsView {

    struct Options: View {
        let settings: AppSettings.PDF
        let config: ChordPro.FontConfig
        @Binding var options: ConfigOptions.FontOptions
        var body: some View {
            ForEach(config.options, id: \.self) { option in
                switch option {
                case .font:
                    FontPickerView(config: config, options: $options, settings: settings)
                case .size:
                    FontSizeSlider(fontSize: $options.size, label: .symbol)
                case .color:
                    ColorPicker("Foreground Color", selection: $options.color, supportsOpacity: false)
                case .background:
                    ColorPicker("Background Color", selection: $options.background, supportsOpacity: false)
                }
            }
        }
    }
}
