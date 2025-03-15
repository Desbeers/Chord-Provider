//
//  AppSettings+PDF.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension AppSettings.PDF {
    enum Preset {
        case light
        case dark
        var settings: AppSettings.PDF {
            switch self {
            case .light:
                AppSettings
                    .PDF(
                        theme:
                            Theme(
                                foreground: .black,
                                foregroundLight: .gray,
                                foregroundMedium: .gray,
                                background: .white
                            ),
                        fonts:
                            Fonts(
                                chord: AppSettings.PDF.Fonts.Font(
                                    size: 10,
                                    color: .accent
                                )
                            )
                    )
            case .dark:
                AppSettings
                    .PDF(
                        theme:
                            Theme(
                                foreground: .white,
                                foregroundLight: .gray,
                                foregroundMedium: .gray,
                                background: .black
                            ),
                        fonts:
                            Fonts(
                                chord: AppSettings.PDF.Fonts.Font(
                                    size: 10,
                                    color: .red
                                )
                            )
                    )
            }
        }
    }
}

extension AppSettings {

    /// Settings for displaying a PDF
    struct PDF: Codable, Equatable {
        /// Theme
        var theme: Theme = Theme()
        /// Fonts
        var fonts: Fonts = Fonts()
    }
}

extension AppSettings.PDF {

    struct Theme: Codable, Equatable {
        var foreground: Color = .black
        var foregroundLight: Color = .secondary
        var foregroundMedium: Color = .secondary
        var background: Color = .white
    }
}

extension AppSettings.PDF {

    struct Fonts: Codable, Equatable {
        var chord: Font = Font(color: .accent)
    }
}

extension AppSettings.PDF.Fonts {
    struct Font: Codable, Equatable {
        var size: Double = 10
        var color: Color = .primary
    }
}
