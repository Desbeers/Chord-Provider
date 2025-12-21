//
//  Song+Markup.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Song {

    /// Pango markup
    public struct Markup: Equatable, Codable, Sendable {

        /// Init the markup
        /// - Parameters:
        ///   - open: The opening markup
        ///   - text: The text
        ///   - close: The closing markup
        public init(open: String = "", text: String = "", close: String = "") {
            self.open = open
            self.text = text
            self.close = close
        }

        /// The opening markup
        public var open: String = ""
        /// The text
        public var text: String = ""
        /// The closing markup
        public var close: String = ""
    }
}
