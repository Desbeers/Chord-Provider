//
//  Song+Section+Line+Tab.swift
//  ChordProviderCore
//
//  © 2026 Nick Berendsen
//

import Foundation

extension Song.Section.Line {

    public struct Tab: Identifiable, Equatable, Codable, Sendable {
        /// Init
        public init(lineID: Int, plain: String, events: [Event] = []) {
            self.lineID = lineID
            self.plain = plain
            self.events = events
        }
        /// Identifiable protocol
        public var id: Int {
            lineID
        }
        /// Plain tab line
        public let plain: String
        /// The line ID
        public let lineID: Int
        /// The events in the column of the tab
        public var events: [Event] = []
    }
}
