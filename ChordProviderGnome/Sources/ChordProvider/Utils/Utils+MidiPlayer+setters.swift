//
//  Utils+MidiPlayer+setters.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import CFluidSynth
import ChordProviderCore

extension Utils.MidiPlayer {

    /// Set the metronome speed
    func setMetronomeBPM(_ bpm: Int) {
        metronomeBPM = max(20, min(bpm, 300))
    }

    /// Set metronome time signature
    /// - Note: "4/4", "6/8", "7/8=2+2+3" for example
    func setMetronomeTimeSignature(_ meter: String) {
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
            timeSignature = TimeSignature(
                numerator: num,
                denominator: den,
                pulsesPerBar: num,
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
            timeSignature = TimeSignature(
                numerator: num,
                denominator: den,
                pulsesPerBar: num,
                accentIndices: Set(accents),
                quarterNoteMultiplier: 1.5
            )
            return
        }
        // MARK: Simple meters
        timeSignature = TimeSignature(
            numerator: num,
            denominator: den,
            pulsesPerBar: num,
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

extension Utils.MidiPlayer {

    /// Set the values for the grid
    /// - Parameter grids: The grid section
    func setGridChords(grids: [Song.Section.Line.GridCell]) {
        self.grids = grids
    }
}

extension Utils.MidiPlayer {

    /// Set the MIDI preset for the player
    func setPreset(_ preset: MidiUtils.Preset) {
        self.preset = preset
    }
}

extension Utils.MidiPlayer {

    /// Set the reference frequency of the player
    /// - Parameter referenceHz: The reference for A2
    func setReferenceFrequency(_ referenceHz: Int) {
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
