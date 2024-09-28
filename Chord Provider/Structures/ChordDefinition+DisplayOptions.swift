//
//  ChordDefinition+DisplayOptions.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension ChordDefinition {

    /// The structure for display options passed to the ``ChordDefinitionView``
    public struct DisplayOptions: Codable, Equatable, Sendable {
        /// Init the structure with default values
        public init(
            showName: Bool = true,
            showNotes: Bool = false,
            showPlayButton: Bool = false,
            rootDisplay: Display.Root = .symbol,
            qualityDisplay: Display.Quality = .symbolized,
            showFingers: Bool = true,
            mirrorDiagram: Bool = false,
            instrument: Instrument = .guitarStandardETuning,
            midiInstrument: Midi.Instrument = .acousticSteelGuitar
        ) {
            self.general = General(
                showName: showName,
                showNotes: showNotes,
                showPlayButton: showPlayButton,
                rootDisplay: rootDisplay,
                qualityDisplay: qualityDisplay,
                showFingers: showFingers,
                mirrorDiagram: mirrorDiagram,
                midiInstrument: midiInstrument
            )
            self.instrument = instrument
        }
        /// General options that should be applied to all scenes
        public var general: General
        /// The instrument
        public var instrument: Instrument

        /// General options that should be applied to all scenes
        public struct General: Codable, Equatable, Sendable  {
            /// Show the name in the chord shape
            public var showName: Bool
            /// Show the notes of the chord
            public var showNotes: Bool
            /// Show a button to play the chord with MIDI
            public var showPlayButton: Bool
            /// Display of the root value
            public var rootDisplay: Display.Root
            /// Display of the quality value
            public var qualityDisplay: Display.Quality
            /// Show the finger position on the diagram
            public var showFingers: Bool
            /// Mirror the chord diagram for lefthanded users
            public var mirrorDiagram: Bool
            /// The instrument to use for playing the chord with MIDI
            public var midiInstrument: Midi.Instrument
        }

        /// Display options for the chord name
        public enum Display {
            /// Root display options
            public enum Root: String, Codable, CaseIterable, Sendable, Identifiable {

                /// Identifiable protocol
                public var id: String {
                    self.rawValue
                }

                /// Display the raw value
                case raw
                /// Display the accessible value
                case accessible
                /// Display the symbol value
                case symbol
            }
            /// Quality display options
            public enum Quality: String, Codable, CaseIterable, Sendable, Identifiable {

                /// Identifiable protocol
                public var id: String {
                    self.rawValue
                }

                /// Display the raw value
                case raw
                /// Display the short value
                case short
                /// Display the symbolized value
                case symbolized
                /// Display the alternative symbol value
                case altSymbol
            }
        }
    }
}
