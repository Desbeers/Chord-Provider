//
//  Song+Chord+Status.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation

extension Song.Chord {

    /// The status of a chord
    enum Status: String {
        /// A standard chord from the SwiftyChords database
        case standard
        /// A transposed chord
        case transposed
        /// A custom defined chord
        case custom
        /// A custom defined chord that is transposed
        case customTransposed
        /// An uknown chord
        case unknown
    }
}
