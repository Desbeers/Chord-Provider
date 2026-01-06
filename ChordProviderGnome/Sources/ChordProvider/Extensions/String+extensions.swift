//
//  String+extensions.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import CAdw

extension String {
    
    /// Escape special characters
    /// - Returns: A cleaned string
    func escapeSpecialCharacters() -> String {
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

extension String {

    /// Wrap text into separate lines and make it identifiable
    /// - Parameter length: The maximum length
    /// - Returns: The wrapped text in an array
    func wrap(by length: Int) -> [ElementWrapper] {
        self.split(by: length).map { ElementWrapper(content: $0) }
    }

    /// Make a String identifiable
    struct ElementWrapper: Identifiable, Equatable {
        var id = UUID()
        var content: String
    }
}
