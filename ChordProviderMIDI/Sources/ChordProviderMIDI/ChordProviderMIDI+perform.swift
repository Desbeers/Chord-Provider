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

    // MARK: Perform a note

    /// Perform a note
    /// - Parameters:
    ///   - voice: The Active Voice
    ///   - note: The start note
    ///   - playbackSettings: The playback settings
    func performNote(
        voice: ActiveVoice,
        note: Int,
        playbackSettings: Chord.Strum.Playback
    ) async {
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

    /// Slide a note using semitone-by-semitone pitch bends
    /// - Parameters:
    ///   - voice: The Active Voice
    ///   - note: The start note
    ///   - playbackSettings: The playback settings
    func performSlide(
        voice: ActiveVoice,
        startNote: Int,
        endNote: Int,
        playbackSettings: Chord.Strum.Playback
    ) async {
        let semitoneDistance = endNote - startNote
        let semitones = abs(semitoneDistance)
        guard semitones > 0 else { return }
        let duration = transport.tempo / Double(metronome.timeSignature.ticksPerBar)
        let segmentDuration = duration / Double(semitones)
        // The bend range spans the whole slide.
        fluid_synth_pitch_wheel_sens(
            synth,
            voice.channel,
            Int32(semitones)
        )
        // Start fully bent.
        let initialBend = semitoneDistance > 0 ? 0 : 16383
        fluid_synth_pitch_bend(
            synth,
            voice.channel,
            Int32(initialBend)
        )
        // Play only the destination note.
        fluid_synth_noteon(
            synth,
            voice.channel,
            Int32(endNote),
            110
        )
        for segment in 1...semitones {
            guard activePlaybackIDs[Int(voice.channel)] == voice.id else {
                break
            }

            let bend: Double

            if semitoneDistance > 0 {
                bend = Double(segment) * 8192.0 / Double(semitones)
            } else {
                bend = 16383.0 - Double(segment) * 8191.0 / Double(semitones)
            }

            fluid_synth_pitch_bend(
                synth,
                voice.channel,
                Int32(bend.rounded())
            )

            try? await Task.sleep(for: .seconds(segmentDuration))
        }
        // Finish perfectly centered
        fluid_synth_pitch_bend(synth, voice.channel, 8192)
        await sustainAndFadeNote(
            voice: voice,
            playbackSettings: playbackSettings
        )
    }

    /// Hammer a note using a pitch bend
    /// - Parameters:
    ///   - voice: The Active Voice
    ///   - startNote: The start note
    ///   - endNote: The end note
    ///   - playbackSettings: The playback settings
    func performHammer(
        voice: ActiveVoice,
        startNote: Int,
        endNote: Int,
        playbackSettings: Chord.Strum.Playback
    ) async {

        let semitoneDistance = endNote - startNote
        guard semitoneDistance != 0 else {
            await sustainAndFadeNote(
                voice: voice,
                playbackSettings: playbackSettings
            )
            return
        }

        fluid_synth_pitch_wheel_sens(
            synth,
            voice.channel,
            Int32(abs(semitoneDistance))
        )

        // Start fully bent so the destination note sounds as the start note.
        let initialBend = semitoneDistance > 0 ? 0 : 16383

        fluid_synth_pitch_bend(
            synth,
            voice.channel,
            Int32(initialBend)
        )

        // Play only the destination note.
        fluid_synth_noteon(
            synth,
            voice.channel,
            Int32(endNote),
            110
        )

        // Wait until the next subdivision.
        let lastSubdivision = transport.subdivision
        while transport.subdivision == lastSubdivision {
            guard activePlaybackIDs[Int(voice.channel)] == voice.id else {
                return
            }
            try? await Task.sleep(for: .milliseconds(1))
        }

        // Instantly "hammer" onto the new fret.
        fluid_synth_pitch_bend(
            synth,
            voice.channel,
            8192
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
    ///   - playbackSettings: The playback settings
    func performBend(
        voice: ActiveVoice,
        startNote: Int,
        endNote: Int,
        playbackSettings: Chord.Strum.Playback
    ) async {
        let duration = transport.tempo / Double(metronome.timeSignature.ticksPerBar)
        let semitoneDistance = endNote - startNote
        let bendRange = abs(semitoneDistance)
        fluid_synth_pitch_wheel_sens(
            synth,
            voice.channel,
            Int32(bendRange)
        )
        /// Start fully bent
        let initialBend = semitoneDistance > 0 ? 0 : 16383

        fluid_synth_pitch_bend(
            synth,
            voice.channel,
            Int32(initialBend)
        )
        /// Play destination note
        fluid_synth_noteon(
            synth,
            voice.channel,
            Int32(endNote),
            110
        )
        let steps = 50
        for step in 0...steps {
            guard activePlaybackIDs[Int(voice.channel)] == voice.id else {
                break
            }
            let t = Double(step) / Double(steps)
            /// Interpolate toward center
            let bend: Double
            if semitoneDistance > 0 {
                bend = t * 8192
            } else {
                bend = 16383 - (t * 8191)
            }
            fluid_synth_pitch_bend(
                synth,
                voice.channel,
                Int32(bend)
            )
            try? await Task.sleep(
                for: .seconds(duration / Double(steps))
            )
        }
        /// Finish perfectly centered
        fluid_synth_pitch_bend(synth, voice.channel, 8192)
        await sustainAndFadeNote(
            voice: voice,
            playbackSettings: playbackSettings
        )
    }

    /// Sustain and fade a note
    /// - Parameters:
    ///   - voice: The voice
    ///   - playbackSettings: The playback settings
    func sustainAndFadeNote(voice: ActiveVoice, playbackSettings: Chord.Strum.Playback) async {
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
