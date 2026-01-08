//
//  Int+extensions.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Int {

    /// Make an Int identifiable
    struct ElementWrapper: Identifiable, Equatable {
        var id = UUID()
        var content: Int
    }

}

extension Array where Element == Int {

    /// Make an Int identifiable
    func toIntWrapper() -> [Int.ElementWrapper] {
        return self.map { Int.ElementWrapper(content: $0) }
    }
}
