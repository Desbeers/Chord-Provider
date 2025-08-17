//
//  Chord+Barre.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Chord {

    /// The structure of a chord barre
    public struct Barre: Equatable, Codable, Hashable, Sendable {
        /// The finger for the barre
        public var finger: Int = 0
        /// the fret for the barre
        public var fret: Int = 0
        /// The first string to barre
        public var startIndex: Int = 0
        /// The last string to barre
        public var endIndex: Int = 0
        /// The calculated length
        public var length: Int {
            endIndex - startIndex
        }
    }
}
