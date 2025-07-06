//
//  SectionView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension RenderView {

    /// Wrapper around a section
    struct SectionViewModifier: ViewModifier {
        /// The optional label of the section
        var label: String?
        /// Draw a background behind the label
        var prominent: Bool = false
        /// The application settings
        let settings: AppSettings
        /// The calculated font
        var font: Font {
            settings.style.fonts.label.swiftUIFont(scale: settings.scale.magnifier)
        }
        /// The body of the `ViewModifier`
        /// - Parameter content: The content of the section
        /// - Returns: A `View` with the wrapped section
        func body(content: Content) -> some View {
            switch settings.display.labelStyle {
            case .inline:
                if let label {
                    sectionLabel(label)
                }
                Rectangle()
                    .frame(width: settings.scale.maxSongLineWidth, height: 1)
                    .foregroundStyle(
                        prominent || label != nil ? settings.style.theme.foregroundLight : Color.clear
                    )
                content
                    .frame(maxWidth: settings.scale.maxSongLineWidth, alignment: .leading)
            case .grid:
                if let label {
                    sectionLabel(label)
                } else {
                    Color.clear
                }
                Rectangle()
                    .frame(width: 1, height: nil)
                    .foregroundStyle(
                        prominent || label != nil ? settings.style.theme.foregroundLight : Color.clear
                    )
                content
            }
        }
        /// Render a label section
        /// - Parameter label: The label
        /// - Returns: A `View`
        func sectionLabel(_ label: String) -> some View {
            VStack {
                switch prominent {
                case true:
                    ProminentLabel(
                        label: label,
                        font: font,
                        settings: settings
                    )
                case false:
                    Text(.init(label))
                        .font(font)
                        .padding(.top, 6)
                        .padding(.bottom, 3)
                }
            }
            .foregroundStyle(settings.style.fonts.label.color, settings.style.fonts.label.background)
        }
    }
}

extension View {

    /// Shortcut to ``RenderView/SectionViewModifier``
    /// - Parameters:
    ///   - label: The optional label of the section
    ///   - prominent: Draw a background behind the label
    ///   - settings: The application settings
    /// - Returns: A modified `View`
    func wrapSongSection(label: String? = nil, prominent: Bool = false, settings: AppSettings) -> some View {
        var optionalLabel: String?
        if let label, !label.isEmpty {
            optionalLabel = label
        }
        return modifier(RenderView.SectionViewModifier(label: optionalLabel, prominent: prominent, settings: settings))
    }
}
