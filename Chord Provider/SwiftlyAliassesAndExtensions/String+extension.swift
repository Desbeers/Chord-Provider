//
//  String+extension.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation

extension String {

    /// Get a part of a String from the subscript
    subscript(_ range: NSRange) -> Self {
        .init(self[index(startIndex, offsetBy: range.lowerBound) ..< index(startIndex, offsetBy: range.upperBound)])
    }
}
