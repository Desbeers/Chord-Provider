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
            repeatingSymbol: ChordPro.Grid.RepeatingSymbol? = nil,
            beatItems: Int = 1,
            isPlayable: Bool = false,
            isInMargin: Bool? = nil
        ) {
            self.strumPattern = strumPattern
            self.strum = strum
            self.barLineSymbol = barLineSymbol
            self.repeatingSymbol = repeatingSymbol
            self.beatItems = beatItems
            self.isPlayable = isPlayable
            self.isInMargin = isInMargin
        }
        // CustomStringConvertible protocol
        public var description: String {
            "\(strumPattern?.rawValue ?? "")\(strum?.rawValue ?? "")\(barLineSymbol?.rawValue ?? "")"
        }
        /// The strum patter
        public var strumPattern: ChordPro.Grid.StrumPattern?
        /// The strum
        public var strum: Chord.Strum?
        /// The bar line symbol
        public var barLineSymbol: ChordPro.Grid.BarLineSymbol?
        /// The repeating symbol
        public var repeatingSymbol: ChordPro.Grid.RepeatingSymbol?
        /// The items in one beat
        public var beatItems: Int
        /// Bool if playable
        public var isPlayable: Bool
        /// Bool if the strum is in the margin of the grid
        public var isInMargin: Bool?
    }
}
