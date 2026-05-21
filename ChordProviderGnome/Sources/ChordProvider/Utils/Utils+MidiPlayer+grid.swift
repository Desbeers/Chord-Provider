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

    /// Start the grid
    func startGrid() {
        /// Stop any other grid or tab tsk
        stopGrid()
        stopTab()
        if self.metronomeTask != nil {
            /// Restart the metronome so it is in sync
            startMetronome()
        }
        gridTask = Task { [weak self] in
            await self?.playGrid()
        }
    }

    /// Stop the grid
    func stopGrid() {
        currentMidiID = -1
        gridTask?.cancel()
        gridTask = nil
    }

    /// Play the chords of the grid
    private func playGrid() async {
        var parts: [Song.Section.Line.Part] = []
        if let grids = self.grids {
            let mappedParts = flatMapParts(grids.map(\.parts))
            parts = mappedParts.filter { part in
                part.content.hasPlayableChord
            }
        }
        while !Task.isCancelled {
            var cells = 1
            for part in parts {
                let chord = part.content.getChord
                if let chord {
                    cells = chord.beatItems
                }
                let tempo = 60.0 / (Double(metronomeBPM) * Double(cells))
                if !Task.isCancelled, let chord, chord.definition.knownChord, chord.definition.strum != .noStrum {
                    self.currentMidiID = part.id
                    Task {
                        await Utils.MidiPlayer.shared.playChord(chord.definition, strum: chord.definition.strum)
                    }
                    try? await Task.sleep(for: .seconds(tempo))
                } else if !Task.isCancelled {
                    try? await Task.sleep(for: .seconds(tempo))
                }
            }
        }
    }

    /// Flatmap grid parts
    /// - Parameter input: The parts
    /// - Returns: Fattened parts 
    func flatMapParts<T>(_ input: [[T]]) -> [T] {
        guard let first = input.first else { return [] }
        return (0..<first.count).flatMap { index in
            input.map { $0[index] }
        }
    }
}
