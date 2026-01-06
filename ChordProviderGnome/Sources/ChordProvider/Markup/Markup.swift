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

    /// Make String identifiable
    struct StringItem: Identifiable, Codable {
        /// The ID of the String
        var id = UUID()
        /// The String
        var string: String
    }
}

extension AnyView {
    func style(_ name: Markup.Class) -> AnyView {
        style(name.description)
    }
}

extension AnyView {
    func levelStyle(_ name : LogUtils.Level) -> AnyView {
        style("log").style("log-\(name.rawValue)")
    }
}
