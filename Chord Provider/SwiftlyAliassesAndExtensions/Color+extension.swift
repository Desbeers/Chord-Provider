//
//  Color+extension.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

/// Make `Color` codable
extension Color: Codable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let swiftColor = SWIFTColor(self)
        let data = try NSKeyedArchiver.archivedData(
            withRootObject: swiftColor,
            requiringSecureCoding: true
        )
        try container.encode(data)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let data = try container.decode(Data.self)
        guard let swiftColor = try NSKeyedUnarchiver
            .unarchivedObject(ofClass: SWIFTColor.self, from: data)
        else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid decoding of archived data")
        }
        self.init(swiftColor: swiftColor)
    }
}

extension Color {
    init(swiftColor: SWIFTColor) {
#if os(macOS)
        self.init(nsColor: swiftColor)
#else
        self.init(uiColor: swiftColor)
#endif
    }
}
