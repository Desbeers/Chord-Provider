//
//  ChordProviderMIDI+playGrid.swift
//  ChordProviderMIDI
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension ChordProviderMIDI {

    /// Play the grid
    public func playGrid() async {
        guard let grids = snapshot.grids else {
            /// There are no tabs to play
            /// - Note: This should not happen...
            return
        }
        let mappedParts = flatMapParts(grids.map(\.parts))
        let parts = mappedParts.filter { part in
            part.content.hasPlayableChord
        }
        /// Stop any other grid or tab task
        stopGrid()
        stopTab()
        /// Wait for the first accent
        while !transport.isAccent {
            try? await Task.sleep(for: .milliseconds(1))
        }
        /// Start the grid
        playbackTasks.grid = Task {
            await playGrids(parts)
        }
    }

    /// Stop the grid
    public func stopGrid() {
        setCurrentMidiID(-1)
        playbackTasks.grid?.cancel()
        playbackTasks.grid = nil
    }

    /// Play the chords in the grids
    private func playGrids( _ parts: [Song.Section.Line.Part]) async {
        /// Tick scheduling
        var nextTick = ContinuousClock.now
        /// Loop the grid until canceled
        while !Task.isCancelled {
            var cells = 1
            for part in parts {
                let chord = part.content.getChord
                if let chord {
                    cells = chord.beatItems
                }
                let tempo = 60.0 / (Double(snapshot.tempo ?? 128) * Double(cells))
                nextTick += .seconds(tempo)
                if !Task.isCancelled, let chord, chord.definition.knownChord, chord.definition.strum != .noStrum {
                    setCurrentMidiID(part.id)
                    await playChord(chord.definition, strum: chord.definition.strum)
                }
                try? await Task.sleep(until: nextTick)
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
