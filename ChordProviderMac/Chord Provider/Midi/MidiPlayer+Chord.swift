//
//  MidiPlayer+Chord.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation
import AVFoundation
import ChordProviderCore

extension MidiPlayer {

    /// Struct for a chord
    struct Chord {
        /// The Music Sequence
        var musicSequence: MusicSequence?
        /// The tracks
        var tracks: [Int: MusicTrack] = [:]
        /// Init the chord
        init() {
            guard NewMusicSequence(&musicSequence) == OSStatus(noErr) else {
                fatalError("Cannot create MusicSequence")
            }
        }

        /// Compose a chord
        /// - Parameters:
        ///   - notes: The notes of the chord
        ///   - instrument: The instrument to use
        /// - Returns: A ``Chord``
        func compose(notes: [Int], instrument: MidiUtils.Instrument) -> Chord {
            var chord = Chord()
            let trackID = chord.addTrack(instrumentID: UInt8(instrument.rawValue))
            var currentPosition: Float = 0
            /// The amount of strings to play
            let strings = notes.count - 1
            /// Add the notes to the chord
            for index: Int in 0...strings {
                chord.addNote(
                    trackID: trackID,
                    note: UInt8(notes[index]),
                    duration: 30 - currentPosition,
                    position: currentPosition
                )
                currentPosition += 0.2
            }
            return chord
        }

        /// Add a track to the chord
        /// - Parameter instrumentID: The ID of the MIDI instrument
        /// - Returns: The track ID
        mutating func addTrack(instrumentID: UInt8) -> Int {
            /// The music track
            var track: MusicTrack?
            guard
                let musicSequence = self.musicSequence,
                MusicSequenceNewTrack(musicSequence, &track) == OSStatus(noErr)
            else {
                fatalError("Cannot add track")
            }
            let trackID = tracks.count
            tracks[trackID] = track
            var inMessage = MIDIChannelMessage(status: 0xC0, data1: instrumentID, data2: 0, reserved: 0)
            if let track {
                MusicTrackNewMIDIChannelEvent(track, 0, &inMessage)
            }
            return trackID
        }

        /// Add a note to the track
        /// - Parameters:
        ///   - trackID: The ID of the track
        ///   - note: The MIDI note
        ///   - duration: The duration
        ///   - position: The position in the track
        func addNote(trackID: Int, note: UInt8, duration: Float, position: Float) {
            let time = MusicTimeStamp(position)
            var musicNote = MIDINoteMessage(
                channel: 0,
                note: note,
                velocity: 127,
                releaseVelocity: 0,
                duration: duration
            )
            guard
                let track = tracks[trackID],
                MusicTrackNewMIDINoteEvent(track, time, &musicNote) == OSStatus(noErr)
            else {
                fatalError("Cannot add Note")
            }
        }
    }
}
