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
    ///   - strum: The kind of strum
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
            case let .normal(note):
                let voice = setupActiveVoice(
                    playbackNote: playbackNote,
                    volume: volume
                )
                Task {
                    await performNote(
                        voice: voice,
                        note: note,
                        transitionNote: playbackNote.transtionNote,
                        playbackSettings: playbackSettings
                    )
                }
            case let .transition(transit):
                let voice = setupActiveVoice(
                    playbackNote: playbackNote,
                    volume: volume                    
                )
                switch transit.technique {
                    case .slide, .slideDown, .slideUp:
                        Task {
                            await performSlide(
                                voice: voice,
                                startNote: transit.from,
                                endNote: transit.to,
                                transitionNote: playbackNote.transtionNote,
                                playbackSettings: playbackSettings
                            )
                        }
                    case .bendUp, .releaseBend:
                        Task {
                            await performBend(
                                voice: voice,
                                startNote: transit.from,
                                endNote: transit.to,
                                transitionNote: playbackNote.transtionNote,
                                playbackSettings: playbackSettings
                            )
                        }
                    case .hammerOn, .pullOff:
                        Task {
                            await performHammer(
                                voice: voice,
                                note: transit.to,
                                transitionNote: playbackNote.transtionNote,
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
        var notes: [Int] = []
        let channel = Int32(playbackNote.stringID)

        switch playbackNote.articulation {
            case let .normal(note):
                notes.append(note)
                // Reset the channel
                fluid_synth_all_notes_off(synth, channel)
                fluid_synth_pitch_bend(synth, channel, 8192)
                // Set the volume
                fluid_synth_cc(synth, channel, 11, volume)
            case let .transition(transit):
                notes.append(transit.from)
                notes.append(transit.to)
        }
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
