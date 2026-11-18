//
//  GdkRGBA+Extensions.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//

import Foundation
import CAdw

extension GdkRGBA {

    /// The libadwaita accent color.
    static var accent: GdkRGBA {
        var rgba = GdkRGBA()
        adw_accent_color_to_rgba(
            adw_style_manager_get_accent_color(adw_style_manager_get_default()),
            &rgba
        )
        return rgba
    }

    init?(hex: String?) {
        var rgba = GdkRGBA()
        guard let hex, gdk_rgba_parse(&rgba, hex) == 1 else {
            return nil
        }
        self = rgba
    }

    init(_ ground: Ground) {
        switch ground {
        case .foreground:
            self = GdkRGBA(red: 0, green: 0, blue: 0, alpha: 1)
        case .background:
            self = GdkRGBA(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }

    enum Ground {
        /// Foreground color.
        case foreground
        /// Background color.
        case background
    }

    static let black = GdkRGBA(.foreground)
    static let white = GdkRGBA(.background)

    var hex: String {
        func byte(_ v: Float) -> UInt32 { UInt32((max(0, min(1, v)) * 255).rounded()) }
        let r = byte(Float(self.red))
        let g = byte(Float(self.green))
        let b = byte(Float(self.blue))
        let a = byte(Float(self.alpha))
        return String(format: "#%02X%02X%02X%02X", r, g, b, a)
    }


    /// Same color with another alpha.
    func withAlpha(_ alpha: Double) -> GdkRGBA {
        GdkRGBA(red: self.red, green: self.green, blue: self.blue, alpha: Float(alpha))
    }

    /// Linear mix with another color. `amount` 0 = self, 1 = other. Result is opaque.
    func mixed(with other: GdkRGBA, _ amount: Double) -> GdkRGBA {
        let floatAmount = Float(amount)
        return GdkRGBA(
            red: self.red + (other.red - self.red) * floatAmount,
            green: self.green + (other.green - self.green) * floatAmount,
            blue: self.blue + (other.blue - self.blue) * floatAmount,
            alpha: self.alpha
        )
    }

    /// Darken the color.
    /// - Parameter amount: 0 is no change, 1 is black.
    /// - Returns: The darker color.
    func darker(by amount: Double) -> GdkRGBA {
        let factor = Float(1 - min(max(amount, 0), 1))
        return GdkRGBA(
            red: red * factor,
            green: green * factor,
            blue: blue * factor,
            alpha: alpha
        )
    }

    /// Lighten the color.
    /// - Parameter amount: 0 is no change, 1 is white.
    /// - Returns: The lighter color.
    func lighten(by amount: Double) -> GdkRGBA {
        let factor = Float(1 - min(max(amount, 0), 1))
        return GdkRGBA(
            red: red / factor,
            green: green / factor,
            blue: blue / factor,
            alpha: alpha
        )
    }

    /// Change the saturation by a factor: 0 gives gray, 1 is unchanged, above 1 is more saturated.
    func saturated(by value: Double) -> GdkRGBA {
        let factor = Float(value)
        let gray = 0.299 * red + 0.587 * green + 0.114 * blue
        func adjust(_ channel: Float) -> Float {
            min(max(gray + (channel - gray) * factor, 0), 1)
        }
        return GdkRGBA(
            red: adjust(red),
            green: adjust(green),
            blue: adjust(blue),
            alpha: alpha
        )
    }

    /// This color drawn on top of an opaque background. Result is opaque.
    func composited(over background: GdkRGBA) -> GdkRGBA {
        GdkRGBA(
            red: self.red * self.alpha + background.red * (1 - self.alpha),
            green: self.green * self.alpha + background.green * (1 - self.alpha),
            blue: self.blue * self.alpha + background.blue * (1 - self.alpha),
            alpha: 1
        )
    }

    /// Approximate perceived brightness, 0...1.
    var luminance: Double {
        Double(0.2126 * self.red + 0.7152 * self.green + 0.0722 * self.blue)
    }
}
