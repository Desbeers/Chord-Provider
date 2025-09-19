//
//  ChordProviderSettings+Export.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordProviderSettings {

    public struct Export: Equatable, Codable, Sendable {
        public var format: Format = .html
    }
}
