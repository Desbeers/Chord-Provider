//
//  ChordProviderSettings+Export.swift
//  ChordProviderCore
//
//  Created by Nick Berendsen on 04/09/2025.
//

import Foundation

extension ChordProviderSettings {

    public struct Export: Equatable, Codable, Sendable {
        public var format: Format = .html
    }
}
