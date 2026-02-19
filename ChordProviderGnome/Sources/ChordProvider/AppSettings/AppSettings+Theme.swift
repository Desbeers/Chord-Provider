//
//  AppSettings+Theme.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension AppSettings {

    /// Settings for the theme
    struct Theme: Codable, Equatable {
        /// Colorfull Window
        var colorfullWindow: Bool = false
        /// The zoom factor of the Render `View`
        var zoom: Double = 1
        /// The font size of the editor
        var editorFontSize: Font = .standard
    }
}

extension AppSettings.Theme {

    /// The font size of the editor
    enum Font: Int, Codable, CaseIterable, CustomStringConvertible, Identifiable {
        case smaller = 10
        case small = 11
        case standard = 12
        case large = 13
        case larger = 14

        var description: String {
            switch self {
            case .smaller: "Smaller"
            case .small: "Small"
            case .standard: "Standard"
            case .large: "Large"
            case .larger: "Larger"
            }
        }
        var id: Self { self }
    }
}