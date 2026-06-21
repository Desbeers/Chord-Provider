//
//  ChordProviderMIDI+perform.swift
//  ChordProviderMIDI
//
//  © 2026 Nick Berendsen
//

import Foundation
import CFluidSynth
import ChordProviderCore

extension ChordProviderMIDI {

    /// Helper to get the pitch bend between two notes
    /// - Parameters:
    ///   - from: Start note
    ///   - to:: End note
    /// - Returns: The pitch bend
    func pitchBend(
        from startNote: Int,
        to endNote: Int
    ) -> Int32 {
        let bendRange = 12.0
        let semitones = Double(endNote - startNote)

        let bend = 8192.0 - semitones / bendRange * 8192.0

        return Int32(bend.rounded())
    }

    // MARK: Perform a note

    /// Perform a note
    /// - Parameters:
    ///   - voice: The Active Voice
    ///   - note: The note
    ///   - transitionNote: The optional transition note
    ///   - playbackSettings: The playback settings
    func performNote(
        voice: ActiveVoice,
        note: Int,
        transitionNote: Int?,
        playbackSettings: Chord.Strum.Playback
    ) async {
        if let transitionNote {
            let bend = pitchBend(from: note, to: transitionNote)
            fluid_synth_pitch_bend(
                synth,
                voice.channel,
                max(0, min(16383, bend))
            )
            // Play only the destination note.
            fluid_synth_noteon(
                synth,
                voice.channel,
                Int32(transitionNote),
                110
            )
        } else {
            fluid_synth_noteon(
                synth,
                voice.channel,
                Int32(note),
                110
            )
            await sustainAndFadeNote(
                voice: voice,
                playbackSettings: playbackSettings
            )
        }
    }

    /// Slide a note using semitone-by-semitone pitch bends
    /// - Parameters:
    ///   - voice: The Active Voice
    ///   - startNote: The start note
    ///   - endNote: The end note
    ///   - transitionNote: The optional transition note
    ///   - playbackSettings: The playback settings
    func performSlide(
        voice: ActiveVoice,
        startNote: Int,
        endNote: Int,
        transitionNote: Int?,
        playbackSettings: Chord.Strum.Playback
    ) async {
        let duration = transport.tempo / Double(metronome.timeSignature.ticksPerBar)
        let semitoneDistance = abs(endNote - startNote)
        let bendStart = pitchBend(from: startNote, to: transitionNote ?? startNote)
        let bendEnd = pitchBend(from: endNote, to: transitionNote ?? endNote)
        let segmentDuration = duration / Double(abs(semitoneDistance))
        let distance = Double(bendEnd - bendStart) / Double(semitoneDistance)
        var value = Double(bendStart)
        for _ in 1...semitoneDistance {
            guard activePlaybackIDs[Int(voice.channel)] == voice.id else {
                break
            }
            value += distance
            fluid_synth_pitch_bend(
                synth,
                voice.channel,
                Int32(value.rounded())
            )

            try? await Task.sleep(for: .seconds(segmentDuration))
        }
        await sustainAndFadeNote(
            voice: voice,
            playbackSettings: playbackSettings
        )
    }

    /// Hammer a note using a pitch bend
    /// - Parameters:
    ///   - voice: The Active Voice
    ///   - note: The note to hammer
    ///   - transitionNote: The optional transition note
    ///   - playbackSettings: The playback settings
    func performHammer(
        voice: ActiveVoice,
        note: Int,
        transitionNote: Int?,
        playbackSettings: Chord.Strum.Playback
    ) async {
        let bend = pitchBend(from: note, to: transitionNote ?? note)
        fluid_synth_pitch_bend(
            synth,
            voice.channel,
            max(0, min(16383, bend))
        )
        await sustainAndFadeNote(
            voice: voice,
            playbackSettings: playbackSettings
        )
    }

    /// Bend a note using a pitch bend
    /// - Parameters:
    ///   - voice: The Active Voice
    ///   - startNote: The start note
    ///   - endNote: The end note
    ///   - transitionNote: The optional transition note
    ///   - playbackSettings: The playback settings
    func performBend(
        voice: ActiveVoice,
        startNote: Int,
        endNote: Int,
        transitionNote: Int?,
        playbackSettings: Chord.Strum.Playback
    ) async {
        let duration = transport.tempo / Double(metronome.timeSignature.ticksPerBar)
        let bendStart = pitchBend(from: startNote, to: transitionNote ?? startNote)
        let bendEnd = pitchBend(from: endNote, to: transitionNote ?? endNote)
        let steps = 50
        let distance = Double(bendEnd - bendStart) / Double(steps)
        var value = Double(bendStart)
        for _ in 0...steps {
            guard activePlaybackIDs[Int(voice.channel)] == voice.id else {
                break
            }
            value += distance
            fluid_synth_pitch_bend(
                synth,
                voice.channel,
                Int32(value.rounded())
            )
            try? await Task.sleep(
                for: .seconds(duration / Double(steps))
            )
        }
        await sustainAndFadeNote(
            voice: voice,
            playbackSettings: playbackSettings
        )
    }

    /// Sustain and fade a note
    /// - Parameters:
    ///   - voice: The voice
    ///   - playbackSettings: The playback settings
    func sustainAndFadeNote(
        voice: ActiveVoice,
        playbackSettings: Chord.Strum.Playback
    ) async {
        guard activePlaybackIDs[Int(voice.channel)] == voice.id else {
            return
        }
        let sustainTime: Double = playbackSettings.duration * transport.tempo
        let sustainStep: Double = 0.1

        var waited: Double = 0
        /// Sustain note
        while waited < sustainTime {
            try? await Task.sleep(for: .seconds(sustainStep))
            waited += sustainStep
        }
        /// Fade out notes (cancellable)
        let fadeSteps = 60
        let fadeInterval: Double = playbackSettings.fadeOut
        /// Minimum gain (-34 dB)
        let minGain: Double = 0.02
        //// Fade curve (1.0 = pure log, >1 = faster drop)
        let curve: Double = 4.0
        /// Fade out
        for step in 0..<fadeSteps {
            let time = Double(step) / Double(fadeSteps - 1)
            let gain = pow(minGain, pow(time, curve))
            guard activePlaybackIDs[Int(voice.channel)] == voice.id else {
                break
            }
            let volume = Int32(Double(voice.volume) * gain)
            fluid_synth_cc(
                synth,
                voice.channel,
                11,
                volume
            )
            try? await Task.sleep(for: .seconds(fadeInterval))
        }
        guard activePlaybackIDs[Int(voice.channel)] == voice.id else {
            return
        }
        for note in voice.notes {
            fluid_synth_noteoff(synth, voice.channel, note)
        }
    }
}
