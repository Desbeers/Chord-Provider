//
//  Collection+Extensions.swift
//  ChordProviderCore
//
//  © 2026 Nick Berendsen
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {

    /// Avoid 'out of range' fatal errors
    /// - Note: Don't use `indices` because it will loop over all elements
    subscript(safe index: Index) -> Iterator.Element? {
        (startIndex <= index && index < endIndex) ? self[index] : nil
    }
}

extension Collection where Element == Int {

    /// The pitch classes of a collection of MIDI notes
    public var pitchClasses: Set<Int> {
        Set(map { $0 % 12 })
    }
}

extension Collection where Element == Int {

    /// The pitch class of the lowest note
    public var bassPitchClass: Int? {
        self.min().map { $0 % 12 }
    }
}

extension Collection where Element: Equatable {

    /// Bool if the collection contains all of the elements
    public func containsAll(_ elements: [Element]) -> Bool {
        elements.allSatisfy { contains($0) }
    }
}
