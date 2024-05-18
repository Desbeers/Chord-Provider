//
//  ChordProviderGeneralOptions.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

/// General settings
/// - Note: Not an extension for ``ChordProviderSettings`` because it is used in the quickview plugins for macOS
struct ChordProviderGeneralOptions: Equatable, Codable, Sendable {
    /// Repeat the whole last chorus when using a *{chorus}* directive
    var repeatWholeChorus: Bool = false
    /// Show the comments in the render
    var showComments: Bool = true
}
