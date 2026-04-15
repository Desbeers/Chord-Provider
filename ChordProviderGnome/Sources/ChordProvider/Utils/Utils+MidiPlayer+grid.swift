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
    func setGridChords(grids: [Song.Section.Line.Grid], preset: MidiUtils.Preset) {
        self.grids = grids
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
        print("Play...")
        var parts: [Song.Section.Line.Part] = []
        if let grids = self.grids {
            let cells = grids.flatMap(\.cells)
            let mappedParts = interleave(cells.map(\.parts))
            parts = mappedParts.filter { part in
                part.chordDefinition != nil
            }
        }
        while !Task.isCancelled {
            var cells = 0
            for part in parts {
                if let cellsPart = part.cells {
                    cells = cellsPart
                }
                let tempo = 60 / (Double(metronomeBPM) * Double(cells))
                if !Task.isCancelled, let chord = part.chordDefinition, chord.knownChord {
                    Task {
                        dump(chord.define)
                        await Utils.MidiPlayer.shared.playChord(chord, preset: preset, strum: chord.strum)
                    }
                    try? await Task.sleep(for: .seconds(tempo))
                } else {
                    print("TextChord")
                    try? await Task.sleep(for: .seconds(tempo))
                }
            }
        }
    }

    func interleave<T>(_ input: [[T]]) -> [T] {
        guard let first = input.first else { return [] }
        return (0..<first.count).flatMap { i in
            input.map { $0[i] }
        }
    }
}
