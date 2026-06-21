//
//  ChordProviderMIDI+setters.swift
//  ChordProviderMIDI
//
//  © 2026 Nick Berendsen
//

import Foundation
import CFluidSynth
import ChordProviderCore

extension ChordProviderMIDI {

    /// Set the program
    /// - Parameter preset: The MIDI preset
    public func setProgram(preset: MidiUtils.Preset) {
        for channel in (0...10) {
            fluid_synth_program_select(
                synth,
                Int32(channel),
                soundFontID,
                0,
                Int32(preset.rawValue)
            )
            fluid_synth_pitch_wheel_sens(
                synth,
                Int32(channel),
                12
            )
        }
        /// Set the metronome channel
        fluid_synth_program_select(
            synth,
            metronome.channel,
            soundFontID,
            0,
            0
        )
    }

    /// Reset all channels
    /// - Note: This will stop any note that is playing
    func resetChannels() {
        for channel in activePlaybackIDs.keys {
            fluid_synth_all_notes_off(synth, Int32(channel))
            fluid_synth_pitch_bend(synth, Int32(channel), 8192)
        }
        activePlaybackIDs.removeAll()
    }

    /// Set metronome time signature
    /// - Note: "4/4", "6/8", "7/8=2+2+3" for example
    public func setMetronomeTimeSignature(_ meter: String) {
        let mainParts = meter.split(separator: "=")
        let signaturePart = mainParts[0]
        let additivePart = mainParts.count > 1 ? mainParts[1] : nil
        let sigParts = signaturePart.split(separator: "/")
        guard sigParts.count == 2,
                let num = Int(sigParts[0]),
                let den = Int(sigParts[1])
        else { return }
        // MARK: Additive meters (explicit grouping)
        if let additivePart,
            let groups = parseAdditiveGroups(additivePart),
            groups.reduce(0, +) == num {
            var accents: [Int] = []
            var index = 0
            for group in groups {
                accents.append(index)
                index += group
            }
            metronome.timeSignature = TimeSignature(
                numerator: num,
                denominator: den,
                ticksPerBar: num,
                accentIndices: Set(accents),
                quarterNoteMultiplier: den == 8 ? 0.5 : 1.0
            )
            return
        }
        // MARK: Compound meters (6/8, 9/8, 12/8)
        if den == 8, num % 3 == 0 {
            let groups = Array(repeating: 3, count: num / 3)
            var accents: [Int] = []
            var index = 0
            for group in groups {
                accents.append(index)
                index += group
            }
            metronome.timeSignature = TimeSignature(
                numerator: num,
                denominator: den,
                ticksPerBar: num,
                accentIndices: Set(accents),
                quarterNoteMultiplier: 1.5
            )
            return
        }
        // MARK: Simple meters
        metronome.timeSignature = TimeSignature(
            numerator: num,
            denominator: den,
            ticksPerBar: num,
            accentIndices: [0],
            quarterNoteMultiplier: 1.0
        )
    }

    /// Additive meter parsing
    private func parseAdditiveGroups(_ string: Substring) -> [Int]? {
        let groups = string.split(separator: "+").compactMap { Int($0) }
        guard !groups.isEmpty else { return nil }
        return groups
    }
}

extension ChordProviderMIDI {

    /// Set the reference frequency of the player
    /// - Parameter referenceHz: The reference for A2
    public func setReferenceFrequency(_ referenceHz: Int) {
        let referenceHz = Double(referenceHz)
        guard let synth else { return }

        let tuningBank: Int32 = 0
        let tuningProgram: Int32 = 0

        /// Build the tuning table
        var tuning = [Double](repeating: 0.0, count: 128)

        let detuneCents = 1200.0 * log2(referenceHz / 440.0)
        for note in 0..<128 {
            tuning[note] = Double(note) * 100.0 + detuneCents
        }

        /// Define the tuning
        _ = tuning.withUnsafeBufferPointer { buffer in
            fluid_synth_activate_key_tuning(
                synth,
                tuningBank,
                tuningProgram,
                "A\(Int(referenceHz)) tuning",
                buffer.baseAddress,
                1
            )
        }

        /// Apply this to all MIDI channels
        for channel in 0..<16 {
            fluid_synth_activate_tuning(
                synth,
                Int32(channel),
                tuningBank,
                tuningProgram,
                1
            )
        }
    }
}
