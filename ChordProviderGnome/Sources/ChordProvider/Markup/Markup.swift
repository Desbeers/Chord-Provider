//
//  Markup.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore
import Adwaita

/// Markup of the song render
enum Markup {
    // Just a placeholder
}

extension Markup {

    /// Make a String identifiable
    struct StringItem: Identifiable, Codable {
        /// The ID of the String
        var id = UUID()
        /// The String
        var string: String
    }
}


