//
//  Song+Section+Line+Grid+Shape.swift
//  ChordProviderCore
//
//  © 2026 Nick Berendsen
//

import Foundation

extension Song.Section.Line.Grid {

    /// The shape of a grid
    public struct Shape: Codable, Sendable {

        /// Init a shape
        /// - Parameters:
        ///   - left: Left margin
        ///   - measures: Total measures
        ///   - beats: Total beats
        ///   - right: Right margin
        public init(
            left: Int = -1,
            measures: Int = 4,
            beats: Int = 4,
            right: Int = -1
        ) {
            self.left = left
            self.measures = measures
            self.beats = beats
            self.right = right
        }
        /// Left margin
        public var left: Int
        /// Total measures
        public var measures: Int
        /// Total beats
        public var beats: Int
        /// Right margin
        public var right: Int
        /// Calculated total amount of cells
        public var totalCells: Int {
            var total = (measures * beats) + measures + 2
            if left >= 1 {
                total += left
            }
            return total
        }
    }
}
