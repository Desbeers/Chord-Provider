//
//  FontUtils+Options.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension FontUtils {

    /// Options for a *font* in **ChordPro**
    /// - Note: a *font* is not like a `Font`; it is more like a *directive font* like `title`
    struct Options: Codable, Equatable {
        /// The details of the font
        var font = FontUtils.Item()
        /// The size of the font
        var size: Double = 10
        /// The color of the font
        var color: Color = .primary
        /// The background color of the font
        /// - Note: Optional, not always used
        var background: Color = .white

        /// The calculated `NSFont`
        func nsFont(scale: Double = 1) -> NSFont {
            NSFont(name: font.postScriptName, size: size * scale) ?? NSFont.systemFont(ofSize: size)
        }

        /// The calculated `Font`
        func swiftUIFont(scale: Double) -> Font {
            Font(NSFont(name: font.postScriptName, size: size * scale) ?? .systemFont(ofSize: size * scale))
        }
    }
}
