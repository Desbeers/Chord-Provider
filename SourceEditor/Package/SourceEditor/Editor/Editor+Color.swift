//
//  Editor+Color.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//

import CSourceEditor

public extension Editor {

    /// An RGBA color.
    ///
    /// A Swift wrapper around `GdkRGBA`, so users of the package don't need the C modules.
    /// All the color math is done by the internal `GdkRGBA` extensions.
    struct Color: Sendable, Hashable {
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

        /// Init from a hex string like `#RRGGBB` or `#RRGGBBAA`.
        /// - Parameter hex: The hex string.
        /// - Returns: The color, or nil if the string is nil or can't be parsed.
        public init?(hex: String?) {
            guard let hex, let rgba = GdkRGBA(hex: hex) else { return nil }
            self.init(rgba)
        }

        /// The color as a hex string, including alpha: `#RRGGBBAA`.
        public var hex: String {
            self.rgba.hex
        }

        /// Approximate perceived brightness, 0...1.
        public var luminance: Double {
            self.rgba.luminance
        }

        /// Same color with another alpha.
        /// - Parameter alpha: The new alpha, 0...1.
        /// - Returns: The new color.
        public func withAlpha(_ alpha: Double) -> Color {
            self.rgba.withAlpha(alpha).color
        }

        /// Linear mix with another color.
        /// - Parameters:
        ///   - other: The other color.
        ///   - amount: 0 is this color, 1 is the other color.
        /// - Returns: The mixed color.
        public func mixed(with other: Color, _ amount: Double) -> Color {
            self.rgba.mixed(with: other.rgba, amount).color
        }

        /// Darken the color.
        /// - Parameter amount: 0 is no change, 1 is black.
        /// - Returns: The darker color.
        public func darker(by amount: Double) -> Color {
            self.rgba.darker(by: amount).color
        }
        /// Lighten the color.
        /// - Parameter amount: 0 is no change, 1 is white.
        /// - Returns: The lighter color.
        public func lighten(by amount: Double) -> Color {
            self.rgba.lighten(by: amount).color
        }

        /// Change the saturation.
        /// - Parameter value: 0 gives gray, 1 is unchanged, above 1 is more saturated.
        /// - Returns: The new color.
        public func saturated(by value: Double) -> Color {
            self.rgba.saturated(by: value).color
        }

        /// This color drawn on top of an opaque background.
        /// - Parameter background: The opaque background color.
        /// - Returns: The opaque result.
        public func composited(over background: Color) -> Color {
            self.rgba.composited(over: background.rgba).color
        }
    }
}

// Internal: the only place the two worlds meet.
extension Editor.Color {

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

    /// The color as a `GdkRGBA`.
    var rgba: GdkRGBA {
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

extension GdkRGBA {

    /// The `GdkRGBA` as an `Editor.Color`.
    var color: Editor.Color {
        Editor.Color(self)
    }
}
