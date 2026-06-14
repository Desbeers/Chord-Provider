//
//  ChordProviderMIDI+playNotes.swift
//  ChordProviderMIDI
//
//  © 2026 Nick Berendsen
//

import Foundation
import CFluidSynth
import ChordProviderCore

extension ChordProviderMIDI {

    /// Play notes polyphonically
    /// - Parameters:
    ///   - notes: The notes to play
    ///   - preset: The MIDI preset
    public func playNotes(_ notes: [PlaybackNote], strum: Chord.Strum?) async {
        /// Get the playback settings for the strum
        /// - Note: If no strum is given, use the default settings
        let playbackSettings = strum?.playbackSettings ?? Chord.Strum.Playback()
        /// Reset the volume
        /// - Note: Because it might be decreased already during fade-out
        var volume = min(Int32(playbackSettings.velocity * 90), 120)
        if playbackTasks.metronome != nil {
            /// Reduce the notes volume a bit if the metronome is playing so you can here the metronome better
            volume -= 25
        }

        // MARK: Play the notes

        /// Strum notes
        for playbackNote in notes {
            switch playbackNote.articulation {
            case .normal:
                let voice = setupActiveVoice(
                    playbackNote: playbackNote,
                    volume: volume
                )
                Task {
                    await performNote(
                        voice: voice,
                        note: playbackNote.midiNote,
                        playbackSettings: playbackSettings
                    )
                }
            case let .transit(endNote, by):
                let voice = setupActiveVoice(
                    playbackNote: playbackNote,
                    volume: volume                    
                )
                switch by {
                    case .slide, .slideDown, .slideUp:
                        Task {
                            await performSlide(
                                voice: voice,
                                startNote: playbackNote.midiNote,
                                endNote: endNote,
                                playbackSettings: playbackSettings
                            )
                        }
                    case .bend:
                        Task {
                            await performBend(
                                voice: voice,
                                startNote: playbackNote.midiNote,
                                endNote: endNote,
                                playbackSettings: playbackSettings
                            )
                        }
                    case .hammerOn, .pullOff:
                        Task {
                            await performHammer(
                                voice: voice,
                                startNote: playbackNote.midiNote,
                                endNote: endNote,
                                playbackSettings: playbackSettings
                            )
                        }                  
                }
            }
            try? await Task.sleep(for: .seconds(playbackSettings.spread))
        }
    }

    /// Setup an active voice
    /// - Returns: A new active voice
    private func setupActiveVoice(
        playbackNote: PlaybackNote,
        volume: Int32
    ) -> ActiveVoice {
        let id = UUID()
        var notes = [playbackNote.midiNote]
        if case let .transit(endNote, _) = playbackNote.articulation {
            notes.append(endNote)
        }
        let channel = Int32(playbackNote.stringID)
        /// Reset the channel
        fluid_synth_all_notes_off(synth, channel)
        fluid_synth_pitch_bend(synth, channel, 8192)
        /// Set the volume
        fluid_synth_cc(synth, channel, 11, volume)
        let voice = ActiveVoice(
            id: id,
            notes: notes.map { Int32($0) },
            channel: channel,
            volume: volume
        )
        /// Store global for the next round of notes
        activePlaybackIDs[playbackNote.stringID] = id
        return voice
    }
}
