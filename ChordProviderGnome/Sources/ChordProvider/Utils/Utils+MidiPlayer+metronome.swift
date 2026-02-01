//
//  Utils+MidiPlayer+metronome.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import CFluidSynth

extension Utils.MidiPlayer {

    // MARK: Metronome API

    /// Start the metronome
    func startMetronome() {
        stopMetronome()
        metronomeTask = Task { [weak self] in
            await self?.runMetronome()
        }
    }

    /// Stop the metronome
    func stopMetronome() {
        metronomeTask?.cancel()
        metronomeTask = nil
    }

    /// Change the metronome BPM while running
    func setMetronomeBPM(_ bpm: Int) {
        metronomeBPM = max(20, min(bpm, 300))
    }

    /// Set metronome meter: "4/4", "6/8", "7/8=2+2+3"
    func setMetronomeMeter(_ meter: String) {

        let mainParts = meter.split(separator: "=")
        let signaturePart = mainParts[0]
        let additivePart = mainParts.count > 1 ? mainParts[1] : nil

        let sigParts = signaturePart.split(separator: "/")
        guard
            sigParts.count == 2,
            let num = Int(sigParts[0]),
            let den = Int(sigParts[1])
        else { return }

        // MARK: Additive meters (explicit grouping)
        if
            let additivePart,
            let groups = parseAdditiveGroups(additivePart),
            groups.reduce(0, +) == num
        {
            var accents: [Int] = []
            var index = 0
            for g in groups {
                accents.append(index)
                index += g
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
            for g in groups {
                accents.append(index)
                index += g
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


    // MARK: Metronome loop

    private func runMetronome() async {
        guard let synth else { return }

        /// Set the instrument; defaults to electrical guitar
        fluid_synth_program_select(
            synth,
            metronomeChannel,
            sfontID,
            0,
            0
        )

        var pulse: Int = 0

        while !Task.isCancelled {

            let intervalNs = UInt64(
                60.0
                / (Double(metronomeBPM) * timeSignature.quarterNoteMultiplier)
                * 1_000_000_000
            )

            let isAccent = timeSignature.accentIndices.contains(pulse)

            let note: Int32 = isAccent ? 76 : 81
            let velocity: Int32 = isAccent ? 120 : 90

            fluid_synth_noteon(synth, metronomeChannel, note, velocity)

            try? await Task.sleep(nanoseconds: intervalNs)
            fluid_synth_noteoff(synth, metronomeChannel, note)

            pulse = (pulse + 1) % timeSignature.pulsesPerBar
        }
    }

    // MARK: Time Signature

    struct TimeSignature {

        let numerator: Int
        let denominator: Int

        /// Total pulses (eighth notes in /8 meters)
        let pulsesPerBar: Int

        /// Accent positions (pulse indices)
        let accentIndices: Set<Int>

        /// Quarter-note length multiplier for BPM
        let quarterNoteMultiplier: Double

        /// Default 4/4 time
        static let fourFour = TimeSignature(
            numerator: 4,
            denominator: 4,
            pulsesPerBar: 4,
            accentIndices: [0],
            quarterNoteMultiplier: 1.0
        )
    }

    // MARK: Additive meter parsing

    private func parseAdditiveGroups(_ string: Substring) -> [Int]? {
        let groups = string.split(separator: "+").compactMap { Int($0) }
        guard !groups.isEmpty else { return nil }
        return groups
    }
}
