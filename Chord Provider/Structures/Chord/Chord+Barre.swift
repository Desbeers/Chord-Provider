//
//  Chord+Barre.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen

import Foundation

extension Chord {

    /// The structure of a chord barre
    struct Barre: Equatable, Codable, Hashable, Sendable {
        /// The finger for the barre
        var finger: Int = 0
        /// the fret for the bar
        var fret: Int = 0
        /// The first string to bar
        var startIndex: Int = 0
        /// The last string to bar
        var endIndex: Int = 0
        /// The calculated length
        var length: Int {
            endIndex - startIndex
        }
    }
}
