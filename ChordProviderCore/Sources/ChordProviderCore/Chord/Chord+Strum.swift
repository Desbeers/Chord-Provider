//
//  Chord+Strum.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Chord {

    /// The strum actions
    public enum Strum: String, Codable, Sendable, CaseIterable, Identifiable, CustomStringConvertible {

        /// Identifiable protocol
        public var id: Self {
            self
        }

        /// CustomStringConvertible protocol
        public var description: String {
            self.rawValue
        }

        /// Down stroke
        case down = "Down stroke"
        /// Accent down stroke
        case downAccent = "Accent down stroke"
        /// Arpeggio down stroke
        case downArpeggio = "Arpeggio down stroke"
        /// Arpeggio Accent down stroke
        case downArpeggioAccent = "Arpeggio Accent down stroke"
        /// Muted down stroke
        case downMuted = "Muted down stroke"
        /// Muted Accent down stroke
        case downMutedAccent = "Muted Accent down stroke"
        /// Staccato down stroke
        case downStaccato = "Staccato down stroke"
        /// Staccato Accent down stroke
        case downStaccatoAccent = "Staccato Accent down stroke"

        /// Up stroke
        case up = "Up stroke"
        /// Accent up stroke
        case upAccent = "Accent up stroke"
        /// Arpeggio up stroke
        case upArpeggio = "Arpeggio up stroke"
        /// Arpeggio Accent up stroke
        case upArpeggioAccent = "Arpeggio Accent up stroke"
        /// Muted up stroke
        case upMuted = "Muted up stroke"
        /// Muted Accent up stroke
        case upMutedAccent = "Muted Accent up stroke"
        /// Staccato up stroke
        case upStaccato = "Staccato up stroke"
        /// Staccato Accent up stroke
        case upStaccatoAccent = "Staccato Accent up stroke"

        /// Do not strum
        case noStrum = "Do not play this chord"

        /// Spacer
        case spacer

        /// List of upward strums
        public static var upStrums: [Chord.Strum] {
            [
                .up,
                .upMuted,
                .upAccent,
                .upArpeggio,
                .upStaccato,
                .upMutedAccent,
                .upArpeggioAccent,
                .upStaccatoAccent
            ]
        }

        public static var options: [Strum] {
            var options = Strum.allCases
            /// Remove none and spacer
            options.removeLast()
            options.removeLast()
            return options
        }

        /// Playback settings
        public var playbackSettings: Playback {
            /// Get the default settings
            var settings = Playback()
            /// Accent
            if rawValue.contains("Accent") {
                settings.velocity = 1.4
            }
            /// Arpeggio
            if rawValue.contains("Arpeggio") {
                settings.spread = 0.1
            }
            /// Muted / Staccato
            if rawValue.contains("Muted") {
                settings.duration = 0.25
                settings.velocity *= 0.8
                settings.fadeOut *= 0.15
            } else if rawValue.contains("Staccato") {
                settings.duration *= 0.4
                settings.fadeOut *= 0.3
            }
            /// Tweak the *up* stroke
            if rawValue.starts(with: "up") {
                settings.velocity *= 0.9
                settings.spread *= 0.8
            }
            return settings
        }

        /// The symbol as String
        /// - Note: Only used on macOS, Linux has fancy SVG symbols :-)
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
                "strumarrow-down-acc-stc"
            case .noStrum:
                "none"
            case .spacer:
                "spacer"
            }

        }
    }

    /// Convert strum characters in the source to fancy symbols
    static var strumCharacterDict: [String: Chord.Strum] {
        [
            "u": .up,
            "up": .up,
            "u+": .upAccent,
            "ua": .upArpeggio,
            "ua+": .upArpeggioAccent,
            "ux": .upMuted,
            "ux+": .upMutedAccent,
            "us": .upStaccato,
            "us+": .upStaccatoAccent,
            "d": .down,
            "dn": .down,
            "d+": .downAccent,
            "da": .downArpeggio,
            "da+": .downArpeggioAccent,
            "dx": .downMuted,
            "dx+": .downMutedAccent,
            "ds": .downStaccato,
            "ds+": .downStaccatoAccent,
            ".": .noStrum
        ]
    }
}

extension Chord.Strum {

    /// Settings for playback
    public struct Playback {

        /// Init the playback settings
        /// - Parameters:
        ///   - velocity: The velocity
        ///   - spread: The spread
        ///   - duration: The duration
        public init(
            velocity: Double = 0.9,
            spread: TimeInterval = 0.025,
            duration: Double = 1.0,
            fadeOut: Double = 0.06
        ) {
            self.velocity = velocity
            self.spread = spread
            self.duration = duration
            self.fadeOut = fadeOut
        }
        /// Accent
        public var velocity: Double
        /// arpeggio
        public var spread: TimeInterval
        /// staccato or muted
        public var duration: Double

        public var fadeOut: Double
    }
}
