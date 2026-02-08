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
