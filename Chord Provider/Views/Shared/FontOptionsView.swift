//
//  FontOptionsView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` to set font options
struct FontOptionsView: View {
    /// The application settings
    @Binding var settings: AppSettings
    /// The body of the `View`
    var body: some View {
        ForEach(FontConfig.allCases, id: \.self) { config in
            VStack {
                switch config {
                case .title:
                    Options(settings: settings, config: config, options: $settings.style.fonts.title)
                case .subtitle:
                    Options(settings: settings, config: config, options: $settings.style.fonts.subtitle)
                case .text:
                    Options(settings: settings, config: config, options: $settings.style.fonts.text)
                case .chord:
                    Options(settings: settings, config: config, options: $settings.style.fonts.chord)
                case .label:
                    Options(settings: settings, config: config, options: $settings.style.fonts.label)
                case .comment:
                    Options(settings: settings, config: config, options: $settings.style.fonts.comment)
                case .tag:
                    Options(settings: settings, config: config, options: $settings.style.fonts.tag)
                case .textblock:
                    Options(settings: settings, config: config, options: $settings.style.fonts.textblock)
                }
            }
            .wrapSettingsSection(title: config.rawValue)
        }
    }
}

extension FontOptionsView {

    /// SwiftUI `View` with the available font options
    struct Options: View {
        /// The application settings
        let settings: AppSettings
        /// The available configuration options for the font
        let config: FontConfig
        /// The options
        @Binding var options: ConfigOptions.FontOptions
        /// The body of the `View`
        var body: some View {
            VStack {
                /// - Note: Fonts
                HStack {
                    ForEach(config.options, id: \.self) { option in
                        switch option {
                        case .font:
                            FontPickerButton(options: $options)
                        case .size:
                            SizeSlider(fontSize: $options.size, label: .symbol)
                        default:
                            EmptyView()
                        }
                    }
                }
                /// - Note: Colors
                HStack {
                    ForEach(config.options, id: \.self) { option in
                        switch option {
                        case .color:
                            ColorPicker("Foreground", selection: $options.color, supportsOpacity: true)
                        case .background:
                            ColorPicker("Background", selection: $options.background, supportsOpacity: true)
                        default:
                            EmptyView()
                        }
                    }
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
                    .padding(.top)
                }
                Divider()
                /// - Note: Preview
                ZStack {
                    Color(settings.style.theme.background)
                        .frame(maxWidth: .infinity)
                    Text(options.nsFont(scale: 1).familyName ?? config.rawValue)
                        .font(.custom(options.font, size: options.size * 1.2))
                        .padding(6)
                        .foregroundStyle(config.color(settings: settings))
                        .background(
                            config.options.contains(.background) ? Color(options.background) : Color.clear
                        )
                        .cornerRadius(3)
                        .padding(3)
                }
            }
        }
    }
}
