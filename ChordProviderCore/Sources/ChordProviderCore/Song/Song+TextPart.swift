//
//  Song+TextPart.swift
//  ChordProviderCore
//
//  © 2026 Nick Berendsen
//

import Foundation

extension Song {

    /// Optionaal prefix and suffix around text
    public struct TextPart: Equatable, Codable, Sendable {

        /// Init the text part
        /// - Parameters:
        ///   - prefix: The opening markup
        ///   - text: The text
        ///   - suffix: The closing markup
        public init(prefix: String = "", text: String = "", suffix: String = "") {
            self.prefix = prefix
            self.text = text
            self.suffix = suffix
        }

        /// The prefix
        public var prefix: String = ""
        /// The text
        public var text: String = ""
        /// The suffix
        public var suffix: String = ""
    }
}

extension Song.TextPart {

    /// Default display
    public var display: String {
        "\(prefix)\(text.escapeSpecialCharacters)\(suffix)"
    }
}