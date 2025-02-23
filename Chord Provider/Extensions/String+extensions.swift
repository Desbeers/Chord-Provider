//
//  String+extensions.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension String: @retroactive Identifiable {

    /// Make a String identifiable
    public var id: Int {
        hash
    }
}

extension String {

    /// Remove prefixes from a String
    /// - Parameter prefixes: An array of prefixes
    /// - Returns: A String with al optional prefixes removed
    func removePrefixes(_ prefixes: [String]? = nil) -> String {
        let prefix = prefixes ?? ["The"]
        let pattern = "^(\(prefix.map { "\\Q" + $0 + "\\E" }.joined(separator: "|")))\\s?"
        guard let range = self.range(of: pattern, options: [.regularExpression, .caseInsensitive]) else {
            return self
        }
        return String(self[range.upperBound...])
    }
}
