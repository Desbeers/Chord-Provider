//
//  Song+Section+Line+StrumGroup.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Song.Section.Line {

    /// The structure of a strum group
    public struct StrumGroup: Equatable, Codable, Identifiable, Hashable, Sendable {
        /// Init the struct
        public init(id: Int, strums: [Song.Section.Line.Strum]) {
            self.id = id
            self.strums = strums
        }
        /// The ID
        public var id: Int
        /// The strums
        public var strums: [Song.Section.Line.Strum]
    }
}
