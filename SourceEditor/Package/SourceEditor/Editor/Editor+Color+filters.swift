//
//  Editor+Color+filters.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//

import CSourceEditor

extension Editor.Color {

    /// Same color with another alpha.
    /// - Parameter alpha: The new alpha, 0...1.
    /// - Returns: The new color.
    public func withAlpha(_ alpha: Double) -> Color {
        Color(red: self.red, green: self.green, blue: self.blue, alpha: alpha)
    }

    /// Linear mix with another color.
    /// - Parameters:
    ///   - other: The other color.
    ///   - amount: 0 is this color, 1 is the other color.
    /// - Returns: The mixed color.
    public func mixed(with other: Color, _ amount: Double) -> Color {
        Color(
            red: self.red + (other.red - self.red) * amount,
            green: self.green + (other.green - self.green) * amount,
            blue: self.blue + (other.blue - self.blue) * amount,
            alpha: self.alpha
        )
    }

    /// Darken the color.
    /// - Parameter amount: 0 is no change, 1 is black.
    /// - Returns: The darker color.
    public func darker(by amount: Double) -> Color {
        let factor = 1 - min(max(amount, 0), 1)
        return Color(
            red: red * factor,
            green: green * factor,
            blue: blue * factor,
            alpha: alpha
        )
    }
    /// Lighten the color.
    /// - Parameter amount: 0 is no change, 1 is white.
    /// - Returns: The lighter color.
    public func lighten(by amount: Double) -> Color {
        let factor = 1 - min(max(amount, 0), 1)
        return Color(
            red: red / factor,
            green: green / factor,
            blue: blue / factor,
            alpha: alpha
        )
    }

    /// Change the saturation.
    /// - Parameter value: 0 gives gray, 1 is unchanged, above 1 is more saturated.
    /// - Returns: The new color.
    public func saturated(by factor: Double) -> Color {
        let gray = 0.299 * red + 0.587 * green + 0.114 * blue
        func adjust(_ channel: Double) -> Double {
            min(max(gray + (channel - gray) * factor, 0), 1)
        }
        return Color(
            red: adjust(red),
            green: adjust(green),
            blue: adjust(blue),
            alpha: alpha
        )
    }

    /// This color drawn on top of an opaque background.
    /// - Parameter background: The opaque background color.
    /// - Returns: The opaque result.
    public func composited(over background: Color) -> Color {
        Color(
            red: self.red * self.alpha + background.red * (1 - self.alpha),
            green: self.green * self.alpha + background.green * (1 - self.alpha),
            blue: self.blue * self.alpha + background.blue * (1 - self.alpha),
            alpha: 1
        )
    }
}
