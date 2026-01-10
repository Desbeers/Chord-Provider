//
// ChordProviderSettings+Diagram
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordProviderSettings {

    /// Settings for displaying chord diagrams
    public struct Diagram: Equatable, Codable, Sendable, CustomStringConvertible {
        /// Confirm to `CustomStringConvertible`
        public var description: String {
            "showName: \(showName) showNotes: \(showNotes) showFingers: \(showFingers) mirror: \(mirror)"
        }
        /// Show the name in the chord shape
        public var showName: Bool = true
        /// Show the notes of the chord
        public var showNotes: Bool = true
        /// Show the finger position on the diagram
        public var showFingers: Bool = true
        /// Mirror the chord diagram for left-handed users
        public var mirror: Bool = false
    }
}
