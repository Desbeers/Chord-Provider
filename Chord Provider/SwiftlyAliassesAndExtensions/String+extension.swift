//
//  String+extension.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension String {

    /// Get a part of a String from the subscript
    subscript(_ range: NSRange) -> Self {
        .init(self[index(startIndex, offsetBy: range.lowerBound) ..< index(startIndex, offsetBy: range.upperBound)])
    }
}

extension String: Identifiable {

    // swiftlint:disable type_name
    /// Make a String identifiable
    public typealias ID = Int
    /// The ID of the string
    public var id: Int {
        hash
    }
    // swiftlint:enable type_name
}
