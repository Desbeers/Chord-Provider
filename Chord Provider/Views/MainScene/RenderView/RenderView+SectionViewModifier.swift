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
            settings.style.fonts.label.swiftUIFont(scale: settings.scale)
        }
        /// The body of the `ViewModifier`
        /// - Parameter content: The content of the section
        /// - Returns: A `View` with the wrapped section
        func body(content: Content) -> some View {
            switch settings.display.labelStyle {
            case .inline:
                Group {
                    /// - Note: For best performance, use `LazyVStack` for  the list view
                    switch settings.display.paging {
                    case .asList:
                        LazyVStack(alignment: .leading) {
                            inlineContent(content: content)
                        }
                    case .asColumns:
                        VStack(alignment: .leading) {
                            inlineContent(content: content)
                        }
                    }
                }
                .padding(.top)
                .frame(idealWidth: settings.maxWidth, maxWidth: settings.maxWidth, alignment: .leading)
            case .grid:
                GridRow {
                    Group {
                        switch prominent {
                        case true:
                            ProminentLabel(
                                label: label ?? "error",
                                font: font,
                                settings: settings
                            )
                        case false:
                            Text(label ?? "")
                                .font(font)
                        }
                    }
                    .foregroundStyle(settings.style.fonts.label.color, settings.style.fonts.label.background)
                    .frame(minWidth: 100, alignment: .trailing)
                    .gridColumnAlignment(.trailing)
                    content
                        .frame(idealWidth: settings.maxWidth, maxWidth: settings.maxWidth, alignment: .leading)
                        .padding(.leading)
                        .overlay(
                            Rectangle()
                                .frame(width: 1, height: nil, alignment: .leading)
                                .foregroundStyle(
                                    prominent || label != nil ? settings.style.theme.foregroundMedium.opacity(0.3) : Color.clear
                                ),
                            alignment: .leading
                        )
                        .gridColumnAlignment(.leading)
                }
            }
        }
        /// The content of the section when viewed inline
        @ViewBuilder func inlineContent(content: Content) -> some View {
            let label = label ?? ""
            if label.isEmpty {
                content
                    .padding(.leading)
            } else {
                Group {
                    switch prominent {
                    case true:
                        ProminentLabel(
                            label: label,
                            font: font,
                            settings: settings
                        )
                    case false:
                        Text(label)
                            .font(font)
                    }
                }
                .foregroundStyle(settings.style.fonts.label.color, settings.style.fonts.label.background)
                Divider()
                content
                    .padding(.leading)
            }
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
        modifier(RenderView.SectionViewModifier(label: label, prominent: prominent, settings: settings))
    }
}
