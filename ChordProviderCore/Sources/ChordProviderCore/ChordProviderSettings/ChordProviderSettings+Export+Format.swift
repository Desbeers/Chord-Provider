//
//  ChordProviderSettings+Export+Format.swift
//  ChordProviderCore
//
//  Created by Nick Berendsen on 04/09/2025.
//

import Foundation

extension ChordProviderSettings.Export {

    public enum Format: String, CaseIterable {
        case html
        case json
        case chordPro = "chordpro"
        case pdf
    }
}
