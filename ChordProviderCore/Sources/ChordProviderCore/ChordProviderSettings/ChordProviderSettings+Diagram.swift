//
// ChordProviderSettings+Diagram
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordProviderSettings {

    /// Settings for displaying chord diagrams
    public struct Diagram: Equatable, Codable, Sendable {
        /// Show the name in the chord shape
        public var showName: Bool = true
        /// Show the notes of the chord
        public var showNotes: Bool = false
        /// Show the finger position on the diagram
        public var showFingers: Bool = true
        /// Mirror the chord diagram for left-handed users
        public var mirror: Bool = false
    }
}
