//
//  String+extensions.swift
//  ChordProCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension String {

    /// Wrapper for text that contains optional prefix and suffix
    /// - Parameter handleBrackets: Bool if brackets should be moved to the prefix and suffix
    /// - Returns:  A ``Song//TextPart`` structure
    ///
    /// Usuage of the *handleBrackets*:
    /// - When parsing a chord we want to have a 'clean' name so everything around
    ///   the chord name should be moved
    func textPart(handleBrackets: Bool) ->Song.TextPart {
        /// Fallback
        var textPart = Song.TextPart(text: self)
        if let match = self.wholeMatch(of: RegexDefinitions.validMarkup) {
            textPart.prefix = String(match.1)
            textPart.text = String(match.2)
            textPart.suffix = String(match.3)
        }
        /// Handle optional brackets around the text
        if handleBrackets, textPart.text.hasPrefix("("), textPart.text.hasSuffix(")") {
            textPart.text.removeFirst()
            textPart.text.removeLast()
            textPart.prefix += "("
            textPart.suffix = ")" + textPart.suffix
        }
        return textPart
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
        public var id = UUID()
        /// The actual string content
        public var content: String
    }
}

extension String {
    
    /// Escape special characters
    /// - Returns: A cleaned string
    public var escapeSpecialCharacters: String {
        if self.contains(["<", ">"]) {
            /// The string contains Pango markup; don't escape
            return self
        } else {
            /// Escape special markup characters
            var escaped = self
            escaped = escaped.replacingOccurrences(of: "&", with: "&amp;")
            escaped = escaped.replacingOccurrences(of: "<", with: "&lt;")
            escaped = escaped.replacingOccurrences(of: ">", with: "&gt;")
            escaped = escaped.replacingOccurrences(of: "\"", with: "&quot;")
            escaped = escaped.replacingOccurrences(of: "'", with: "&apos;")
            return escaped
        }
    }
}

extension Array where Element == String {

    /// Make a `String` array identifiable
    public var toElementWrapper: [String.ElementWrapper] {
        self.map { String.ElementWrapper(content: $0) }
    }
}
