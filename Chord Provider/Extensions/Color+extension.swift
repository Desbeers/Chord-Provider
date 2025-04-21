//
//  Color+extension.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension Color: Codable {

    /// Override equatable confirmation in a little bit less strict version
    static func == (lhs: Color, rhs: Color) -> Bool {
        lhs.toHex == rhs.toHex
    }

    /// Make `Color` encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let hexColor = self.toHex
        try container.encode(hexColor)
    }

    /// Make `Color` decodable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        if let result = Color(hex: string) {
            self.init(result)
        } else {
            self.init(Color.primary)
        }
    }

    /// Generate a random dark Color
    static var randomDark: Color {
        return Color(
            red: .random(in: 0...0.5),
            green: .random(in: 0...0.5),
            blue: .random(in: 0...0.5)
        )
    }

    /// Generate a random light Color
    static var randomLight: Color {
        return Color(
            red: .random(in: 0.7...1),
            green: .random(in: 0.7...1),
            blue: .random(in: 0.7...1)
        )
    }

    /// Convert Color to NSColor
    var nsColor: NSColor {
        NSColor(self)
    }
}

extension Color {

    /// Init a `Color` with an hex value
    /// - Parameter hex: The hex value
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        // swiftlint:disable identifier_name
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        // swiftlint:enable identifier_name
        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, opacity: a)
    }
}

extension Color {

    /// Convert a `Color` to ha hex value as `String`
    var toHex: String {
        let uic = NSColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return "#000000"
        }
        let string = "#"
        // swiftlint:disable identifier_name
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        // swiftlint:enable identifier_name
        if components.count >= 4 {
            a = Float(components[3])
        }

        if a != Float(1.0) {
            /// - Note: With transparency
            return string + String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            /// - Note: Without transparency
            return string + String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}
