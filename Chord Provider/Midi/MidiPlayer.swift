//
//  MidiPlayer.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//
//  Thanks: https://readdarek.com/how-to-play-midi-in-swift/

import SwiftUI
@preconcurrency import AVFoundation

/// Play a ``ChordDefinition`` with its MIDI values
actor MidiPlayer {
    /// Make it a shared actor
    static let shared = MidiPlayer()
    /// The MIDI player
    var midiPlayer: AVMIDIPlayer?
    /// The URL of the SoundBank
    /// - Note: A stripped version of the `GeneralUser GS MuseScore` bank
    var bankURL: URL
    /// Private init to make sure the actor is shared
    private init() {
        /// Get the Sound Font
        guard let bankURL = Bundle.main.url(forResource: "GuitarSoundFont", withExtension: "sf2") else {
            fatalError("SoundFont not found.")
        }
        self.bankURL = bankURL
    }

    /// Prepare a chord
    /// - Parameter chord: The ``Chord`` to play
    func prepareChord(chord: Chord) {
        /// Black magic
        var data: Unmanaged<CFData>?
        guard
            let musicSequence = chord.musicSequence,
            MusicSequenceFileCreateData(
                musicSequence,
                MusicSequenceFileTypeID.midiType,
                MusicSequenceFileFlags.eraseFile,
                480,
                &data
            ) == OSStatus(noErr)
        else {
            fatalError("Cannot create music midi data")
        }
        if let data {
            let midiData = data.takeUnretainedValue() as Data
            do {
                try midiPlayer = AVMIDIPlayer(data: midiData, soundBankURL: bankURL)
            } catch let error {
                fatalError(error.localizedDescription)
            }
        }
        self.midiPlayer?.prepareToPlay()
    }

    /// Play a chord with its MIDI values
    /// - Parameters:
    ///   - notes: The notes to play
    ///   - instrument: The ``Chord/Instrument`` to use
    func playChord(notes: [Int], instrument: Midi.Instrument = .acousticNylonGuitar) async {
        let composer = Chord()
        let chord = composer.compose(notes: notes, instrument: instrument)
        prepareChord(chord: chord)
        if let midiPlayer {
            midiPlayer.currentPosition = 0
            await midiPlayer.play()
        }
    }
}
