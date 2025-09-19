//
//  Output.swift
//  ChordProviderCLI
//
//  Created by Nick Berendsen on 17/08/2025.
//

import Foundation
import ArgumentParser
import ChordProviderCore

extension Chord.Instrument: @retroactive ExpressibleByArgument { }

extension ChordProviderSettings.Export.Format: @retroactive ExpressibleByArgument { }
