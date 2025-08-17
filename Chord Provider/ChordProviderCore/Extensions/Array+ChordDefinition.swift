//
//  Array+ChordDefinition.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Array where Element == ChordDefinition {

    /// Find all chord definitions matching a root note
    /// - Parameter root: The root note
    /// - Returns: All matching chord definitions
    func matching(root: Chord.Root) -> [ChordDefinition] {
        self.filter { $0.root == root }
    }

    /// Find all chord definitions matching sharp and flat versions of a root note
    /// - Parameter sharpAndflatRoot: The root note
    /// - Returns: All matching chord definitions
    func matching(sharpAndflatRoot: Chord.Root) -> [ChordDefinition] {
        self.filter { $0.root == sharpAndflatRoot || $0.root == sharpAndflatRoot.swapSharpForFlat }
    }

    /// Find all chord definitions matching a quality
    /// - Parameter quality: The quality
    /// - Returns: All matching chord definitions
    func matching(quality: Chord.Quality) -> [ChordDefinition] {
        self.filter { $0.quality == quality }
    }

    /// Find all chord definitions matching a slash bass note
    /// - Parameter slash: The slash note
    /// - Returns: All matching chord definitions
    func matching(slash: Chord.Root?) -> [ChordDefinition] {
        return self.filter { $0.slash == slash }
    }

    /// Find all chord definitions matching a base fret
    /// - Parameter baseFret: The base fret
    /// - Returns: All matching chord definitions
    func matching(baseFret: Int) -> [ChordDefinition] {
        return self.filter { $0.baseFret == baseFret }
    }

    /// Find all chord definitions matching a chord group
    /// - Parameter group: The group
    /// - Returns: All matching chord definitions
    func matching(group: Chord.Group) -> [ChordDefinition] {
        return self.filter { $0.quality.group == group }
    }
}

extension Array {

    /// Get all combinations of an array
    ///  - Note: Used to get all chord notes combinations in `getChordComponents`
    var combinationsWithoutRepetition: [[Element]] {
        guard !isEmpty else { return [[]] }
        return Array(self[1...]).combinationsWithoutRepetition.flatMap { [$0, [self[0]] + $0] }
    }
}
