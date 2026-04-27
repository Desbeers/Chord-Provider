//
//  Song+Section+Line+Grid+Shape.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Song.Section.Line.Grid {

    public struct Shape: Codable, Sendable {
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
        public var left: Int
        public var measures: Int
        public var beats: Int
        public var right: Int

        public var totalCells: Int {
            var total = (measures * beats) + measures + 2
            if left >= 1 {
                total += left
            }
            return total
        }
    }
}