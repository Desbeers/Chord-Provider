//
//  Utils+MidiPlayer+grid.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore
import CFluidSynth

extension Utils.MidiPlayer {

    /// Set the values for the grid
    /// - Parameters:
    ///   - section: The grid section
    ///   - tempo: Tempo of the song
    ///   - preset: The MIDI preset to use
    func setGridChords(section: Song.Section, preset: MidiUtils.Preset) {
        self.section = section
        self.preset = preset
    }

    /// Start the chords
    func startChords() {
        stopChords()
        gridTask = Task { [weak self] in
            await self?.playChords()
        }
    }

    /// Stop the chords
    func stopChords() {
        gridTask?.cancel()
        gridTask = nil
    }

    /// Play the chords of the grid
    private func playChords() async {
        while !Task.isCancelled {
            if let section = section {
                var parts: [Song.Section.Line.Part] = []
                for line in section.lines {
                    let allParts =
                        //(line.parts ?? []) +
                        (line.grid?
                            .flatMap(\.cells)
                            .flatMap(\.parts) ?? [])
                    for part in allParts where part.chordDefinition != nil || part.text == "." {
                        parts.append(part)
                    }
                }
                for part in parts {
                    let tempo: UInt64 = UInt64(60 / Double(metronomeBPM) * 1_000_000_000)
                    if !Task.isCancelled, let chord = part.chordDefinition, chord.knownChord {
                        Task {
                            await Utils.MidiPlayer.shared.playChord(chord, preset: preset, strum: chord.strum)
                        }
                        try? await Task.sleep(nanoseconds: tempo)
                    } else {
                        try? await Task.sleep(nanoseconds: tempo)
                    }
                }
            }
        }
    }
}
