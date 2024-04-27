//
//  ChordProviderError.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation

enum ChordProviderError: String, LocalizedError {
    case createPdfError
    case exportFolderError
    case noAccessToSongError
    case saveSettingsError
    case writeDocumentError
}
