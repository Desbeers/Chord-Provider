//
//  ChordProviderError.swift
//  ChordProviderCore
//
//  Created by Nick Berendsen on 17/08/2025.
//

import Foundation

/// All errors that can happen in Chord Provider Core
enum ChordProviderError: String, LocalizedError {
    case fileNotFound
    case jsonDecoderError

    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "The file is not found"
        case .jsonDecoderError:
            return "JSON decoder error"
        }
    }
}
