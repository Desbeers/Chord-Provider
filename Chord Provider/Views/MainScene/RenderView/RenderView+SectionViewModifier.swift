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
            settings.style.fonts.label.swiftUIFont(scale: settings.scale.scale)
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
                    .frame(width: nil, height: 1)
                    .foregroundStyle(
                        prominent || label != nil ? settings.style.theme.foregroundLight : Color.clear
                    )
                content
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

                //.background(Color.randomLight)
            //Spacer()

//            let _ = print(settings.display.labelStyle)
//            switch settings.display.paging {
//            case .asList:
//
//                switch settings.display.labelStyle {
//                case .grid:
//                    GridRow {
//                        //VStack {
//                            Text(label ?? "NO LABEL")
//                            content
//                        //}
//                    }
//                case .inline:
//                    GridRow {
//                        Text(label ?? "NO LABEL")
//                            .font(.title)
//                    }
//                    GridRow {
//                        content
//                    }
//                }
//            case .asColumns:
//                VStack {
//                    Text(label ?? "NO LABEL")
//                    content
//                }
//            }

            //content
        }
//            switch settings.display.labelStyle {
//            case .inline:
//                content
//                    .background(Color.randomLight)
////                Section(content: {
////                    content
////                        .background(Color.randomLight)
////                        .listRowSeparator(.hidden)
////                        .frame(idealWidth: settings.maxWidth, maxWidth: settings.maxWidth, alignment: .leading)
////
////                }, header: {
////                    Text(label ?? "ERROR")
////                })
////                .listSectionSeparator(.hidden)
//
////                VStack(alignment: .leading) {
////                    inlineContent(content: content)
////                }
////                .listRowSeparator(.visible)
////                .background(Color.randomLight)
////                Group {
////                    /// - Note: For best performance, use `LazyVStack` for  the list view
////                    switch settings.display.paging {
////                    case .asList:
////                        LazyVStack(alignment: .leading) {
////                            inlineContent(content: content)
////                        }
////                    case .asColumns:
////                        VStack(alignment: .leading) {
////                            inlineContent(content: content)
////                        }
////                    }
////                }
//                .padding(.top)
//                .frame(idealWidth: settings.maxWidth, maxWidth: settings.maxWidth, alignment: .leading)
//            case .grid:
//                GridRow {
//                    Group {
//                        switch prominent {
//                        case true:
//                            ProminentLabel(
//                                label: label ?? "error",
//                                font: font,
//                                settings: settings
//                            )
//                        case false:
//                            Text(.init(label ?? ""))
//                                .font(font)
//                        }
//                    }
//                    .foregroundStyle(settings.style.fonts.label.color, settings.style.fonts.label.background)
//                    .frame(minWidth: 100, alignment: .trailing)
//                    .gridColumnAlignment(.trailing)
//                    content
//                        .frame(idealWidth: settings.maxWidth, maxWidth: settings.maxWidth, alignment: .leading)
//                        .background(Color.randomLight)
//                        .padding(.leading)
//                        .overlay(
//                            Rectangle()
//                                .frame(width: 1, height: nil, alignment: .leading)
//                                .foregroundStyle(
//                                    prominent || label != nil ? settings.style.theme.foregroundLight : Color.clear
//                                ),
//                            alignment: .leading
//                        )
//                        .gridColumnAlignment(.leading)
//                }
//            }
//        }
        /// The content of the section when viewed inline


        @ViewBuilder func sectionLabel(_ label: String) -> some View {
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
                }
            }
            .foregroundStyle(settings.style.fonts.label.color, settings.style.fonts.label.background)
            //.frame(maxWidth: .infinity, alignment: settings.display.paging == .asList ? .leading : .trailing)
        }

        @ViewBuilder func inlineContent(content: Content) -> some View {
            let label = label ?? ""
            if label.isEmpty {
                content
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
                        Text(.init(label))
                            .font(font)
                    }
                }
                .foregroundStyle(settings.style.fonts.label.color, settings.style.fonts.label.background)
                Divider()
                content
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
        var optionalLabel: String?
        if let label, !label.isEmpty {
            optionalLabel = label
        }
        return modifier(RenderView.SectionViewModifier(label: optionalLabel, prominent: prominent, settings: settings))
    }
}
