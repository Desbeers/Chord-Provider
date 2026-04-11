//
//  Song+Section+Line+Strum.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Song.Section.Line {

    /// The structure of strums
    public struct Strums: Equatable, Codable, Identifiable, Hashable, Sendable {
        /// Init the struct
        public init(id: Int, strums: [Song.Section.Line.Strum]) {
            self.id = id
            self.strums = strums
        }
        /// The ID
        public var id: Int
        /// The strums
        public var strums: [Song.Section.Line.Strum]
    }

    /// The structure of a strum
    public struct Strum: Equatable, Codable, Identifiable, Hashable, Sendable {
        /// Init the struct
        public init(
            id: Int = 0,
            action: Chord.Strum = .none,
            beat: String = "",
            tuplet: String = "&"
        ) {
            self.id = id
            self.action = action
            self.beat = beat
            self.tuplet = tuplet
        }
        /// The ID
        public var id: Int = 0
        /// The strum action
        public var action: Chord.Strum = .none
        /// The beat symbol
        public var beat: String = ""
        /// The tuplet symbol
        public var tuplet: String = "&"
        /// Optional top symbol
        public var topSymbol: String {
            switch self.action {
            case .upAccent, .downAccent:
                ">"
            case .upMuted, .downMuted:
                "x"
            default:
                " "
            }
        }
    }
}

extension Song.Section.Line.Strum {


}
