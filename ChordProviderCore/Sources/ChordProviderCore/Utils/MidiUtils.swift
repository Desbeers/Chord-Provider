//
//  MidiUtils.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

public enum MidiUtils {
    /// The URL of the SoundFont in the bundle
    public static let soundFont: URL? = Bundle.module.url(forResource: "GuitarSoundFont", withExtension: "sf2")
}

public extension MidiUtils {

    /// The preset for playing MIDI
    enum Preset: Int, CaseIterable, CustomStringConvertible, Identifiable, Codable, Sendable {
        public var description: String {
            switch self {
            case .acousticNylonGuitar:
                "Acoustic Nylon Guitar"
            case .acousticSteelGuitar:
                "Acoustic Steel Guitar"
            case .electricCleanGuitar:
                "Electric Clean Guitar"
            case .electricYazzGuitar:
                "Electric Yazz Guitar"
            case .electricMutedGuitar:
                "Electric Muted Guitar"
            }
        }
        public var id: Self { self }
        /// Acoustic nylon guitar
        case acousticNylonGuitar = 1
        /// Acoustic steel guitar
        case acousticSteelGuitar = 2
        /// Electric electric guitar
        case electricCleanGuitar = 3
        /// Electric jazz guitar
        case electricYazzGuitar = 4
        /// Electric muted guitar
        case electricMutedGuitar = 5

    }
}
