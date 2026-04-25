//
//  Song+Section+Line+Part+Strum.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Song.Section.Line.Part {

    /// The structure of a strum
    public struct Strum: Equatable, Codable, Hashable, Sendable, CustomStringConvertible {
        /// Init the struct
        public init(
            strumPattern: ChordPro.Grid.StrumPattern? = nil,
            strum: Chord.Strum? = nil,
            barLineSymbol: ChordPro.Grid.BarLineSymbol? = nil,
            beatItems: Int = 1,
            playable: Bool = false
        ) {
            self.strumPattern = strumPattern
            self.strum = strum
            self.barLineSymbol = barLineSymbol
            self.beatItems = beatItems
            self.playable = playable
        }
        // CustomStringConvertible protocol
        public var description: String {
            "\(strumPattern?.rawValue ?? "")\(strum?.rawValue ?? "")\(barLineSymbol?.rawValue ?? "")"
        }
        /// The strum patter
        public var strumPattern: ChordPro.Grid.StrumPattern?
        /// The strum
        public var strum: Chord.Strum?
        /// The barLineSymbol
        public var barLineSymbol: ChordPro.Grid.BarLineSymbol?
        /// The items in one beat
        public var beatItems: Int
        /// Playable
        public var playable: Bool
    }
}
