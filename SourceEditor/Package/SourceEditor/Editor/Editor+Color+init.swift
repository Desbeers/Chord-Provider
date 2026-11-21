//
//  Editor+Color+init.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//

import CSourceEditor

extension Editor.Color {

    /// Init from a hex string like `#RRGGBB` or `#RRGGBBAA`.
    /// - Parameter hex: The hex string.
    /// - Returns: The color, or nil if the string is nil or can't be parsed.
    init?(hex: String?) {
        var rgba = GdkRGBA()
        guard let hex, gdk_rgba_parse(&rgba, hex) == 1 else {
            return nil
        }
        self = Color(rgba)
    }

    /// Init from a `GdkRGBA`.
    /// - Parameter rgba: The `GdkRGBA`.
    init(_ rgba: GdkRGBA) {
        self.init(
            red: Double(rgba.red),
            green: Double(rgba.green),
            blue: Double(rgba.blue),
            alpha: Double(rgba.alpha)
        )
    }

    /// Init with foreground or background.
    init(_ ground: Ground) {
        let value: Double = Color.darkMode ? (ground == .foreground ? 1 : 0 ) : (ground == .foreground ? 0 : 1 )
        self = Color(red: value, green: value, blue: value, alpha: 1)
    }

    /// Foreground or background.
    enum Ground {
        /// Foreground color.
        case foreground
        /// Background color.
        case background
    }
}
