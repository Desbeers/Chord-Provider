//
//  Chord+Component.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen

import Foundation

extension Chord {

    /// The structure of a chord component
    public struct Component: Identifiable, Hashable, Sendable {
        /// The unique ID
        public var id = UUID()
        /// The note
        public let note: Chord.Root
        /// The MIDI note value
        public let midi: Int?
    }
}
