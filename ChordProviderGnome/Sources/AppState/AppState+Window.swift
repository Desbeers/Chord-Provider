//
//  AppState+Window.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension AppState {

    struct WindowSize: Codable, Equatable, Sendable {
        /// The width of the window
        var width = 800
        /// The height of the window
        var height = 600
    }
}
