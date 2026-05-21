//
//  ChordProviderMIDI.swift
//  ChordProviderMIDI
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore
import CFluidSynth


/// Actor-based MIDI player
public actor ChordProviderMIDI {

    // MARK: Shared instance

    /// The shared instance of the MIDI player
    public static let shared = ChordProviderMIDI()

    // MARK: FluidSynth state

    /// The settings for FluidSynth
    var settings: OpaquePointer?
    /// The actual synth for FluidSynth
    var synth: OpaquePointer?
    /// The driver for FluidSynth
    var driver: OpaquePointer?
    /// The current SoundFont ID
    var soundFontID: Int32 = -1

    // MARK: MIDI channels

    var activePlaybackIDs: [Int: UUID] = [:]

    /// The transport state
    /// - Note: This is to keep track on MIDI timing
    var transport = TransportState()

    // MARK: Metronome state

    /// Settings for the metronome
    var metronome = MetronomeSettings()

    /// MIDI playback tasks
    var playbackTasks = PlaybackTasks()

    /// Current playback snapshot
    /// - Written only by the actor
    /// - Read externally by the GTK render
    public nonisolated(unsafe) private(set) var snapshot = PlaybackSnapshot()

    // MARK: Init

    /// Init the MIDI engine
    private init() {
        settings = new_fluid_settings()
        guard let settings else { return }

        /// Louder but safe volume
        fluid_settings_setnum(settings, "synth.gain", 0.9)

        fluid_settings_setint(settings, "audio.period-size", 512)
        fluid_settings_setint(settings, "audio.periods", 3)

        fluid_settings_setint(settings, "synth.polyphony", 64)

        fluid_settings_setint(settings, "synth.reverb.active", 0)
        fluid_settings_setint(settings, "synth.chorus.active", 0)

        /// Platform specific settings
#if os(macOS)
        fluid_settings_setstr(settings, "audio.driver", "coreaudio")
#elseif os(Linux)
        fluid_settings_setstr(settings, "audio.driver", "pipewire")
#endif
        synth = new_fluid_synth(settings)
        guard let synth else { return }

        /// Load the driver
        driver = new_fluid_audio_driver(settings, synth)

        /// Load the SoundFont
        /// - Note: Don't reset the channels (3th argument)
        ///         because its only a small SoundFont that does not have the standard channels
        if let sfPath = MidiUtils.soundFont {
            soundFontID = fluid_synth_sfload(synth, sfPath.path(), 1)
        } else {
            /// This should not happen, the sound font is a part of the bundle
            print("ERROR: Sound font not found!")
        }
    }
}

// MARK: Setters for items that should be readable by the GUI

extension ChordProviderMIDI {

    /// Set the ID of the current MIDI note
    /// - Parameter currentMidiID: The ID of the current MIDI note
    func setCurrentMidiID(_ currentMidiID: Int) {
        self.snapshot.currentMidiID = currentMidiID
    }
}

extension ChordProviderMIDI {

    /// Set the values for the grid
    /// - Parameter grids: The grid section
    public func setGridChords(_ grids: [Song.Section.Line.GridCell]) {
        self.snapshot.grids = grids
    }
}


extension ChordProviderMIDI {

    /// Set the values for the grid
    /// - Parameter grids: The grid section
    public func setTabNotes(_ tabs: [Song.Section.Line.Tab]) {
        self.snapshot.tabs = tabs
    }
}
