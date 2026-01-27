//
//  ChordProviderError.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

/// All errors that can happen in Chord Provider Core
enum ChordProviderError: String, LocalizedError {
    case fileNotFound
    case jsonDecoderError
    case noChordsDefined

    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            "The file is not found"
        case .jsonDecoderError:
            "JSON decoder error"
        case .noChordsDefined:
            "No chords are defined"
        }
    }
}
