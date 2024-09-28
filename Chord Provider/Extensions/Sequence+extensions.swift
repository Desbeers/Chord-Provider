//
//  Sequence+Extensions.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

public extension Sequence {

    /// Filter a Sequence by an unique keypath
    /// - Parameter keyPath: The keypath
    /// - Returns: The unique Sequence
    func uniqued<Type: Hashable>(by keyPath: KeyPath<Element, Type>) -> [Element] {
        var set = Set<Type>()
        return filter { set.insert($0[keyPath: keyPath]).inserted }
    }
}
