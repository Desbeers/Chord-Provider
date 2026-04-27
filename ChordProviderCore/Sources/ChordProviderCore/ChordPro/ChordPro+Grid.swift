//
// ChordPro+Grid.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
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
        case singleBarLine = "|"
        case doubleBarLine = "||"
        case endBarLine = "|."
        case startRepeatBarLine = "|:"
        case stopRepeatBarLine = ":|"
        case combinedStopStartRepeatBarLine = ":|:"
        /// Display a bar line
        public var display: String {
            self.rawValue
        }
    }

    /// Text that is a strum pattern
    public enum StrumPattern: String, Sendable, Codable {
        case strumWithSymbol = "|S"
        case strumWithoutSymbol = "|s"
        /// Display a strum pattern
        public var display: String {
            switch self {
            case .strumWithSymbol: "|"
            case .strumWithoutSymbol: " "
            }
        }
    }

    /// Text that is some kind of repeating
    public enum RepeatingSymbol: String, Sendable, Codable {
        case playLikePreviousMeasure = "%"
        case  repeatLastTwoMeasures = "%%"
    }
}