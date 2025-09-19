//
//  Midi.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

// MARK: Play a `ChordDefinition` with MIDI

/// Play a ``ChordProviderCore/ChordDefinition`` with MIDI
enum Midi {
    /// Just a placeholder
}

extension Midi {

    /// The available MIDI instruments for the player
    enum Instrument: Int, CaseIterable, Codable, Sendable, Identifiable {

        /// Identifiable protocol
        var id: String {
            "\(self.rawValue)"
        }

        /// Acoustic Nylon Guitar
        case acousticNylonGuitar = 24
        /// Acoustic Steel Guitar
        case acousticSteelGuitar
        /// Electric Jazz Guitar
        case electricJazzGuitar
        /// Electric Clean Guitar
        case electricCleanGuitar
        /// Electric Muted Guitar
        case electricMutedGuitar
        /// Overdriven Guitar
        case overdrivenGuitar
        /// Distortion Guitar
        case distortionGuitar

        //// The label for the instrument
        var label: String {
            switch self {
            case .acousticNylonGuitar:
                return "Acoustic Nylon Guitar"
            case .acousticSteelGuitar:
                return "Acoustic Steel Guitar"
            case .electricJazzGuitar:
                return "Electric Jazz Guitar"
            case .electricCleanGuitar:
                return "Electric Clean Guitar"
            case .electricMutedGuitar:
                return "Electric Muted Guitar"
            case .overdrivenGuitar:
                return "Overdriven Guitar"
            case .distortionGuitar:
                return "Distortion Guitar"
            }
        }
    }
}
