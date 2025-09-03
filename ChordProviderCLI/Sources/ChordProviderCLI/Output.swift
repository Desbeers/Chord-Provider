//
//  Output.swift
//  chordprovider
//
//  Created by Nick Berendsen on 17/08/2025.
//

import Foundation
import ArgumentParser
import ChordProviderCore

enum OutputFormat: String, CaseIterable, ExpressibleByArgument {
    case html
    case json
    case source
}

extension Chord.Instrument: @retroactive ExpressibleByArgument { }
