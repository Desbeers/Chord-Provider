//
//  Editor+Color.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//

import CAdw
import CSourceEditor

/// Shortcut for color.
public typealias Color = Editor.Color

extension Editor {

    /// An RGBA color.
    ///
    /// A Swift wrapper around `GdkRGBA`, so users of the package don't need the C modules.
    /// All the color math is done by the internal `GdkRGBA` extensions.
    public struct Color: Sendable, Hashable {

        /// The red channel, 0...1.
        public var red: Double
        /// The green channel, 0...1.
        public var green: Double
        /// The blue channel, 0...1.
        public var blue: Double
        /// The alpha channel, 0...1.
        public var alpha: Double

        /// Init the color from its channels.
        /// - Parameters:
        ///   - red: The red channel, 0...1.
        ///   - green: The green channel, 0...1.
        ///   - blue: The blue channel, 0...1.
        ///   - alpha: The alpha channel, 0...1. Default is opaque.
        public init(red: Double, green: Double, blue: Double, alpha: Double = 1) {
            self.red = red
            self.green = green
            self.blue = blue
            self.alpha = alpha
        }
    }
}

extension Editor.Color {

    // MARK: Static colors.

    /// White
    static let black = Color(red: 0, green: 0, blue: 0, alpha: 1)
    /// Black
    static let white = Color(red: 1, green: 1, blue: 1, alpha: 1)

    /// The system accent color.
    public static var systemAccent: Color {
        var rgba = GdkRGBA()
        adw_accent_color_to_rgba(
            adw_style_manager_get_accent_color(adw_style_manager_get_default()),
            &rgba
        )
        return Color(rgba)
    }
}

extension Editor.Color {

    /// Approximate perceived brightness, 0...1.
    public var luminance: Double {
        Double(0.2126 * self.red + 0.7152 * self.green + 0.0722 * self.blue)
    }

    /// Bool if the current style is dark.
    static var darkMode: Bool {
        adw_style_manager_get_dark(adw_style_manager_get_default()) != 0
    }
}

extension Editor.Color {

    // MARK: Converts.

    /// The color as a hex string, including alpha: `#RRGGBBAA`.
    var hex: String {
        func byte(_ value: Float) -> UInt32 { UInt32((max(0, min(1, value)) * 255).rounded()) }
        let red = byte(Float(self.red))
        let green = byte(Float(self.green))
        let blue = byte(Float(self.blue))
        let alpha = byte(Float(self.alpha))
        return String(format: "#%02X%02X%02X%02X", red, green, blue, alpha)
    }

    /// The color as a `GdkRGBA`.
    var gdkRGBA: GdkRGBA {
        GdkRGBA(red: Float(red), green: Float(green), blue: Float(blue), alpha: Float(alpha))
    }

    /// Pango colors
    public var pango: (red: UInt16, green: UInt16, blue: UInt16) {
        func channel(_ value: Float) -> UInt16 {
            UInt16((min(max(value, 0), 1) * 65535).rounded())
        }
        return (channel(Float(self.red)), channel(Float(self.green)), channel(Float(self.blue)))
    }
}
