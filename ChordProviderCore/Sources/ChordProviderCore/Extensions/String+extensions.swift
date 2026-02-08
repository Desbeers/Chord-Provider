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
        var markup = Song.Markup(open: "<span color=\"red\">", text: self, close: "</span>")
        if let match = self.wholeMatch(of: ChordPro.RegexDefinitions.optionalMarkup) {
            markup.open = String(match.1 ?? "")
            markup.text = String(match.2)
            markup.close = String(match.3 ?? "")
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

extension String {

    /// Wrap a `String` into separate lines and make it identifiable
    /// - Parameter length: The maximum length
    /// - Returns: The wrapped text in an array
    public func wrap(by length: Int) -> [ElementWrapper] {
        self.split(by: length).map { ElementWrapper(content: $0) }
    }
}

// MARK: Make a `String` identifiable

extension String {

    /// Make a `String` identifiable by wrapping it in a `struct`
    public var toElementWrapper: String.ElementWrapper {
        ElementWrapper(content: self)
    }

    /// A wrapper for a `String` to make it identifiable
    public struct ElementWrapper: Identifiable, Equatable, Hashable, Comparable, Sendable, Codable {
        /// Comparable protocol conformance
        public static func < (lhs: String.ElementWrapper, rhs: String.ElementWrapper) -> Bool {
            lhs.content < rhs.content
        }
        /// Init the `ElementWrapper`
        /// - Parameter content: The content of the `String`
        public init(content: String) {
            self.content = content
        }
        /// The unique ID of the wrapped `String`
        /// - Note: Don't use the `String` itself because its not guaranteed to be unique
        public let id = UUID()
        public var content: String
    }
}

extension Array where Element == String {

    /// Make a `String` array identifiable
    public var toElementWrapper: [String.ElementWrapper] {
        self.map { String.ElementWrapper(content: $0) }
    }
}
