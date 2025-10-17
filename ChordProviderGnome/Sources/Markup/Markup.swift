//
//  Markup.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation

/// Markup of the song render
enum Markup {
    // Just a placeholder
}

extension Markup {

    /// Make String identifiable
    struct StringItem: Identifiable, Codable {
        /// The ID of the String
        var id = UUID()
        /// The String
        var string: String
    }
}
