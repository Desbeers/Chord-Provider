//
//  String+extensions.swift
//  ChordProCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension String {

    /// Wrapper for text that contains optional markup
    var markup: Song.Markup {
        /// Fallback; this should not happen
        var markup = Song.Markup(start: "<span color=\"red\">", text: self, end: "</span>")
        if let match = self.wholeMatch(of: Chord.RegexDefinitions.optionalMarkup) {
            markup.start = String(match.1 ?? "")
            markup.text = String(match.2)
            markup.end = String(match.3 ?? "")
            return markup
        }
        return markup
    }
}

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

extension String {

    /// Split a string at a space  by a length
    /// - Parameter length: The maximum lenght
    /// - Returns: An array of strings
    public func split(by length: Int) -> [String] {
        var result = [String]()
        var collectedWords = [String]()
        collectedWords.reserveCapacity(length)
        var count = 0
        let words = self.components(separatedBy: " ")

        for word in words {
            count += word.count + 1
            if count > length {
                /// Reached the desired length
                result.append(collectedWords.map { String($0) }.joined(separator: " ") )
                collectedWords.removeAll(keepingCapacity: true)
                count = word.count
                collectedWords.append(word)
            } else {
                collectedWords.append(word)
            }
        }
        /// Append the remainder
        if !collectedWords.isEmpty {
            result.append(collectedWords.map { String($0) }.joined(separator: " "))
        }

        return result
    }
}
