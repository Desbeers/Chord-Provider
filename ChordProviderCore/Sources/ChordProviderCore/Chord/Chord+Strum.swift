//
//  Chord+Strum.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Chord {

    /// The strum actions
    public enum Strum: String, Codable, Sendable {

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
            case .none:
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
            ".": .none
        ]
    }
}

extension Chord.Strum {

    struct Playback {

        enum Direction {
            case up
            case down
        }

        enum Articulation {
            case normal
            case staccato
            case muted
        }

        // MARK: - Core

        var direction: Direction = .down

        /// Time between notes in a strum (seconds)
        var spread: TimeInterval = 0.012

        /// Overall velocity multiplier
        var velocityMultiplier: Double = 1.0

        /// Note length scaling
        var durationMultiplier: Double = 1.0

        /// Random timing variation (+/- seconds)
        var timingJitter: TimeInterval = 0.002

        /// Articulation affects duration & feel
        var articulation: Articulation = .normal

        // MARK: - Advanced shaping

        /// Velocity shaping across strings (0...1 → multiplier)
        var velocityCurve: (Double) -> Double = { progress in
            // Default: slight decay for downstroke feel
            1.0 - (progress * 0.2)
        }

        // MARK: - Derived helpers

        func velocity(for index: Int, count: Int, base: Double) -> Double {
            let progress = count > 1 ? Double(index) / Double(count - 1) : 0
            return base
                * velocityMultiplier
                * velocityCurve(progress)
        }

        func duration(from base: TimeInterval) -> TimeInterval {
            let articulationFactor: Double = {
                switch articulation {
                case .normal:   return 1.0
                case .staccato: return 0.5
                case .muted:    return 0.25
                }
            }()

            return base * durationMultiplier * articulationFactor
        }

        func noteTime(base: TimeInterval, index: Int) -> TimeInterval {
            let jitter = Double.random(in: -timingJitter...timingJitter)
            return base + (Double(index) * spread) + jitter
        }
    }
}
