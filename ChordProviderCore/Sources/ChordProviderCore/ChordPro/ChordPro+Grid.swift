//
// ChordPro+Grid.swift
//  ChordProviderCore
//
//  © 2026 Nick Berendsen
//

import Foundation

extension ChordPro {

    /// Stuff that can be part of a *Grid* 
    public enum Grid {
        // Just a placeholder
    }

}

extension ChordPro.Grid {

    /// Text that is a bar line
    public enum BarLineSymbol: String, Sendable, Codable {

        case singleBarLine
        case doubleBarLine
        case endBarLine
        case startRepeatBarLine
        case stopRepeatBarLine
        case combinedStopStartRepeatBarLine

        /// Display a bar line
        public var display: String {
            switch self {
            case .singleBarLine: "|"
            case .doubleBarLine: "||"
            case .endBarLine: "|."
            case .startRepeatBarLine: "|:"
            case .stopRepeatBarLine: ":|"
            case .combinedStopStartRepeatBarLine: ":|:"
            }
        }

        /// Convert bar line characters
        public static var characterDictionary: [String: ChordPro.Grid.BarLineSymbol] {
            [
                "|": .singleBarLine,
                "||": .doubleBarLine,
                "|.": .endBarLine,
                "|:": .startRepeatBarLine,
                ":|": .stopRepeatBarLine,
                ":|:": .combinedStopStartRepeatBarLine
            ]
        }
    }

    /// Text that is a strum pattern
    public enum StrumPattern: String, Sendable, Codable {

        case strumWithSymbol
        case strumWithoutSymbol

        /// Display a strum pattern
        public var display: String {
            switch self {
            case .strumWithSymbol: "|"
            case .strumWithoutSymbol: " "
            }
        }

        /// Convert strum pattern characters
        public static var characterDictionary: [String: ChordPro.Grid.StrumPattern] {
            [
                "|S": .strumWithSymbol,
                "|s": .strumWithoutSymbol
            ]
        }
    }

    /// Text that is some kind of repeating
    public enum RepeatingSymbol: String, Sendable, Codable {

        case playLikePreviousMeasure
        case repeatLastTwoMeasures

        /// Display a repeating symbol
        public var display: String {
            switch self {
            case .playLikePreviousMeasure: "%"
            case .repeatLastTwoMeasures: "&&"
            }
        }

        /// Convert strum pattern characters
        public static var characterDictionary: [String: ChordPro.Grid.RepeatingSymbol] {
            [
                "%": .playLikePreviousMeasure,
                "%%": .repeatLastTwoMeasures
            ]
        }
    }
}