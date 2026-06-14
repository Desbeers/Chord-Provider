//
//  Output.swift
//  ChordProviderCLI
//
//  © 2026 Nick Berendsen
//

import Foundation
import ArgumentParser
import ChordProviderCore

extension Instrument.Kind: @retroactive ExpressibleByArgument { }

extension ChordProviderSettings.Export.Format: @retroactive ExpressibleByArgument { }
