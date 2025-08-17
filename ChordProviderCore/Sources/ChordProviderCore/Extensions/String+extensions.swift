//
//  String+extensions.swift
//  ChordProCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension String {

    /// Remove prefixes from a String
    /// - Returns: A String with al optional prefixes removed
    func removePrefixes(_ prefixes: [String]) -> String {
        let pattern = "^(\(prefixes.map { "\\Q" + $0 + "\\E" }.joined(separator: "|")))\\s"
        guard let range = self.range(of: pattern, options: [.regularExpression, .caseInsensitive]) else {
            return self
        }
        return String(self[range.upperBound...])
    }
}
