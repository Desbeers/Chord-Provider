//
//  Color+extension.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension Color: Codable {

    /// Make `Color` encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let nsColor = NSColor(self)
        let data = try NSKeyedArchiver.archivedData(
            withRootObject: nsColor,
            requiringSecureCoding: true
        )
        try container.encode(data)
    }

    /// Make `Color` decodable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let data = try container.decode(Data.self)
        guard let nsColor = try NSKeyedUnarchiver
            .unarchivedObject(ofClass: NSColor.self, from: data)
        else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid decoding of archived data")
        }
        self.init(nsColor: nsColor)
    }

    /// Generate a random dark Color
    static var randomDark: Color {
        return Color(
            red: .random(in: 0...0.6),
            green: .random(in: 0...0.6),
            blue: .random(in: 0...0.6)
        )
    }

    /// Generate a random light Color
    static var randomLight: Color {
        return Color(
            red: .random(in: 0.6...1),
            green: .random(in: 0.6...1),
            blue: .random(in: 0.6...1)
        )
    }
}

extension Color {
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
            return string + String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return string + String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}
