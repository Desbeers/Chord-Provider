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

        public init(start: String = "", text: String = "", end: String = "") {
            self.start = start
            self.text = text
            self.end = end
        }
        /// The opening markup
        public var start: String = ""
        /// The text
        public var text: String = ""
        /// The closing markup
        public var end: String = ""
    }
}
