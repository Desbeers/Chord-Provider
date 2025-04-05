//
//  FontStyle.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

/// All configuration options
enum ConfigOptions {
    // Just a placeholder
}

extension ConfigOptions {

    /// Options for a *font* in **ChordPro**
    /// - Note: a *font* is not like a `Font`; it is more like a *directive font* like `title`
    struct FontOptions: Codable, Equatable {
        /// The font family
        /// - Note: Only used for the GUI to select a font
        var fontFamily: String = "SF Pro"
        /// The actual font as `String`
        var font: String = "SFPro-Regular"
        /// The size of the font
        var size: Double = 10
        /// The color of the font
        var color: Color = .primary
        /// The background color of the font
        /// - Note: Optional, not always used
        var background: Color = .white

        /// The calculated `NSFont`
        var nsFont: NSFont {
            NSFont(name: font, size: size) ?? NSFont.systemFont(ofSize: size)
        }

        /// The calculated `Font`
        func swiftUIFont(scale: Double) -> Font {
            Font(NSFont(name: font, size: size * scale) ?? .systemFont(ofSize: size * scale))
        }
    }
}
