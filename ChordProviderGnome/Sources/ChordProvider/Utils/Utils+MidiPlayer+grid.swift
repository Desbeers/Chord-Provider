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
    ///   - grids: The grid section
    ///   - tempo: Tempo of the song
    ///   - preset: The MIDI preset to use
    func setGridChords(grids: [Song.Section.Line.GridCell], preset: MidiUtils.Preset) {
        self.grids = grids
        self.preset = preset
    }

    /// Start the chords
    func startChords() {
        if self.metronomeTask != nil {
            /// Restart the metronome
            startMetronome()
        }
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
        var parts: [Song.Section.Line.Part] = []
        if let grids = self.grids {
            let mappedParts = interleave(grids.map(\.parts))
            parts = mappedParts.filter { part in
                part.chordDefinition != nil
            }
        }
        while !Task.isCancelled {
            var cells = 1
            for part in parts {
                if let cellsPart = part.strum?.beatItems {
                    cells = cellsPart
                }
                // self.currentChord = part.id
                let tempo = 60.0 / (Double(metronomeBPM) * Double(cells))
                if !Task.isCancelled, let chord = part.chordDefinition, chord.knownChord, chord.strum != .noStrum {
                    self.currentChord = part.id
                    Task {
                        await Utils.MidiPlayer.shared.playChord(chord, preset: preset, strum: chord.strum)
                    }
                    try? await Task.sleep(for: .seconds(tempo))
                } else if !Task.isCancelled {
                    try? await Task.sleep(for: .seconds(tempo))
                }
            }
        }
    }

    func interleave<T>(_ input: [[T]]) -> [T] {
        guard let first = input.first else { return [] }
        return (0..<first.count).flatMap { index in
            input.map { $0[index] }
        }
    }
}
