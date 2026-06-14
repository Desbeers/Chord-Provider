//
//  Song+Section+Line+Part.swift
//  ChordProviderCore
//
//  © 2026 Nick Berendsen
//

import Foundation

extension Song.Section.Line {

    /// A part in the ``Song/Section/Line``
    public struct Part: Identifiable, Equatable, Codable, Sendable, CustomStringConvertible {
        /// Init the *Part*
        public init(
            id: Int = 0,
            content: Content = .text(textPart: .init()),
        ) {
            self.id = id
            self.content = content
        }

        // CustomStringConvertible protocol
        public var description: String {
            "\(content)"
        }

        /// The unique ID of the part
        public var id: Int

        /// The content of the part
        public var content: Content

        /// Bool if the part should be dimmed in a view
        public var dimmed: Bool = false
    }
}

