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
        public init(id: Int = 0, action: Song.Section.Line.Strum.Action = .none, beat: String = "", tuplet: String = "&") {
            self.id = id
            self.action = action
            self.beat = beat
            self.tuplet = tuplet
        }
        /// The ID
        public var id: Int = 0
        /// The strum action
        public var action: Action = .none
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

    /// Convert strum characters in the source to fancy symbols
    static var strumCharacterDict: [String: Song.Section.Line.Strum.Action] {
        [
            "u":    .up,
            "up":   .up,
            "u+":   .upAccent,
            "ua":   .upArpeggio,
            "ua+":  .upArpeggioAccent,
            "ux":   .upMuted,
            "ux+":  .upMutedAccent,
            "us":   .upStaccato,
            "us+":  .upStaccatoAccent,
            "d":    .down,
            "dn":   .down,
            "d+":   .downAccent,
            "da":   .downArpeggio,
            "da+":  .downArpeggioAccent,
            "dx":   .downMuted,
            "dx+":  .downMutedAccent,
            "ds":   .downStaccato,
            "ds+":  .downStaccatoAccent,
            ".":    .none
        ]
    }
}

extension Song.Section.Line.Strum {

    /// The strum actions
    public enum Action: String, Codable, Sendable {

        /// Up stroke
        case up
        /// Accent up stroke
        case upAccent
        /// Arpeggio up stroke
        case upArpeggio
        /// Arpeggio Accent up stroke
        case upArpeggioAccent
        /// Muted up stroke
        case upMuted
        /// Muted Accent up stroke
        case upMutedAccent
        /// Staccato up stroke
        case upStaccato
        /// Staccato Accent up stroke
        case upStaccatoAccent

        /// Down stroke
        case down
        /// Accent down stroke
        case downAccent
        /// Arpeggio down stroke
        case downArpeggio
        /// Arpeggio Accent down stroke
        case downArpeggioAccent
        /// Muted down stroke
        case downMuted
        /// Muted Accent down stroke
        case downMutedAccent
        /// Staccato down stroke
        case downStaccato
        /// Staccato Accent down stroke
        case downStaccatoAccent

        /// Do not stroke
        case none

        /// Spacer
        case spacer

        // TODO: make me nice!
        public var symbol: String {
            if self.rawValue.starts(with: "up") {
                "\u{2191}"
            } else if self.rawValue.starts(with: "down") {
                "\u{2193}"
            } else {
                "."
            }
        }
        /// The SVG icon in the bundle
        public var svgIcon: String {
            switch self {
            case .up:
                "strumarrow-up"
            case .upAccent:
                "strumarrow-up-acc"
            case .upArpeggio:
                "strumarrow-up-arp"
            case .upArpeggioAccent:
                "strumarrow-up-acc-arp"
            case .upMuted:
                "strumarrow-up-mut"
            case .upMutedAccent:
                "strumarrow-up-mut-acc"
            case .upStaccato:
                "strumarrow-up-stc"
            case .upStaccatoAccent:
                "strumarrow-up-acc-stc"
            case .down:
                "strumarrow-down"
            case .downAccent:
                "strumarrow-down-acc"
            case .downArpeggio:
                "strumarrow-down-arp"
            case .downArpeggioAccent:
                "strumarrow-down-acc-arp"
            case .downMuted:
                "strumarrow-down-mut"
            case .downMutedAccent:
                "strumarrow-down-mut-acc"
            case .downStaccato:
                "strumarrow-down-stc"
            case .downStaccatoAccent:
                "strumarrow-up-acc-stc"
            case .none:
                "none"
            case .spacer:
                "spacer"
            }

        }
    }
}
