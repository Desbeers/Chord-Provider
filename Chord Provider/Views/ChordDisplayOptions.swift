//
//  ChordDisplayOptions.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

/// An `Observable` Class with SwiftUI elements
///
/// This class contains SwiftUI Toggles and Pickers you can add to your application to change the appearance of the chord diagrams.
@Observable public final class ChordDisplayOptions {
    /// Init the Class with optional defaults
    public init(defaults: ChordDefinition.DisplayOptions? = nil) {
        self.displayOptions = defaults ?? .init()
        // swiftlint:disable:next force_unwrapping
        self.definition = ChordDefinition(name: "C", instrument: .guitarStandardETuning)!
    }
    /// All the ``ChordDefinition/DisplayOptions``
    public var displayOptions: ChordDefinition.DisplayOptions
    /// All the values of a ``ChordDefinition``
    /// - Note: Used for editing a chord
    public var definition: ChordDefinition
}
