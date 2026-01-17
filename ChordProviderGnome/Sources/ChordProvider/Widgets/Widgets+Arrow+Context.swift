//
//  Widgets+Arrow+Context.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Widgets.Arrow {

    /// The context of an arrow drawing
    public final class Context {

        /// Init the context
        /// - Parameters:
        ///   - direction: The direction of the arrow
        ///   - length: The length of the arrow
        ///   - dash: Show the arrow with dashes
        init(direction: Direction, length: Int, dash: Bool) {
            self.direction = direction
            self.dash = dash
            self.length = length
        }
        /// The direction of the arrow
        let direction: Direction
        /// The length of the arrow
        let length: Int
        /// Show the arrow with dashes
        let dash: Bool
    }
}
