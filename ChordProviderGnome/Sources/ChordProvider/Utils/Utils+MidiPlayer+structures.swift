//
//  Utils+MidiPlayer+structures.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension Utils.MidiPlayer {

    // MARK: - Transport State

    /// Runtime state for the MIDI transport clock
    ///
    /// This state is used to keep track of playback timing,
    /// beat subdivisions, and scheduling of the next transport tick.
    struct TransportState {

        /// Current transport tick
        var tick: Int = 0

        /// Current subdivision within the tick
        var subdivision: Int = 0

        /// Indicates whether the current tick is accented
        var isAccent: Bool = false

        /// Scheduled time for the next transport event
        var nextTransportTime = ContinuousClock.now
    }

    // MARK: - Playback Snapshot

    /// Snapshot of the current playback position and content
    ///
    /// This structure contains the currently active MIDI event
    /// together with the grids and tabs that are being played.
    struct PlaybackSnapshot {

        /// Identifier of the currently playing MIDI event
        var currentMidiID: Int = -1

        /// Grid cells currently scheduled for playback
        var grids: [Song.Section.Line.GridCell]?

        /// Tab lines currently scheduled for playback
        var tabs: [Song.Section.Line.Tab]?
    }

    // MARK: - Metronome Settings

    /// Configuration for the metronome.
    struct MetronomeSettings {

        /// Tempo in beats per minute
        var bpm: Int = 120

        /// Fixed MIDI channel used by the metronome
        let channel: Int32 = 15

        /// Active time signature
        var timeSignature: TimeSignature = .fourFour
    }

    // MARK: - Playback Tasks

    /// Collection of asynchronous playback tasks
    ///
    /// Each task controls a dedicated playback subsystem.
    struct PlaybackTasks {

        /// Main transport timing task
        var transport: Task<Void, Never>?

        /// Metronome playback task
        var metronome: Task<Void, Never>?

        /// Chord grid playback task
        var grid: Task<Void, Never>?

        /// Tab playback task
        var tab: Task<Void, Never>?
    }

    // MARK: - Playback Note

    /// A MIDI note scheduled for playback
    struct PlaybackNote: Sendable {

        /// String number associated with the note
        let string: Int

        /// MIDI note number
        let note: Int

        /// Playback articulation
        let articulation: Articulation

        /// Playback articulation types
        enum Articulation: Sendable {

            /// A normal note without transition
            case normal

            /// A note that transitions to another MIDI note
            ///
            /// - Parameters:
            ///   - to: Destination MIDI note
            ///   - by: Transition type
            case transit(to: Int, by: ChordPro.Tab.NoteTransition)
        }
    }

    // MARK: - Active Voice

    /// Active MIDI voice currently playing
    ///
    /// A voice may contain multiple MIDI notes
    /// for example during note transitions
    struct ActiveVoice {

        /// Unique identifier for the voice
        let id: UUID

        /// MIDI notes currently active for the voice
        let notes: [Int32]

        /// MIDI channel used for playback
        let channel: Int32

        /// Playback volume for the voice
        let volume: Int32
    }

    // MARK: - Time Signature

    /// A musical time signature describing how beats are grouped within a bar
    /// and how transport ticks map to musical structure.
    ///
    /// This type defines the rhythmic grid used by the playback engine.
    /// It is independent of MIDI and expresses timing in abstract ticks.
    struct TimeSignature {

        /// The upper number of the time signature (beats per bar).
        let numerator: Int

        /// The lower number of the time signature (note value that represents one beat).
        let denominator: Int

        /// Total number of transport ticks in one full bar.
        ///
        /// This defines the resolution of the internal timing grid.
        /// Example: `4` means one tick per quarter note in 4/4.
        let ticksPerBar: Int

        /// Tick indices that should be accented within a bar.
        ///
        /// These are zero-based positions in the bar.
        /// Example for 4/4: `[0]` accents the first beat of each bar.
        let accentIndices: Set<Int>

        /// Multiplier used to convert BPM (based on quarter notes)
        /// into the internal tick timing system.
        ///
        /// - `1.0` means one tick equals one quarter note
        /// - Higher values increase internal resolution per beat
        let quarterNoteMultiplier: Double

        /// Standard 4/4 time signature.
        static let fourFour = TimeSignature(
            numerator: 4,
            denominator: 4,
            ticksPerBar: 4,
            accentIndices: [0],
            quarterNoteMultiplier: 1.0
        )
    }
}