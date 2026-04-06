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
                for line in section.lines {
                    if let grids = line.grid {
                        for grid in grids {
                            for cell in grid.cells {
                                for part in cell.parts {
                                    let tempo: UInt64 = UInt64(60 / Double(metronomeBPM) * 1_000_000_000)
                                    if !Task.isCancelled, let chord = part.chordDefinition, chord.knownChord {
                                        let notes = chord.components.compactMap { value in
                                            if let midi = value.midi {
                                                return Int32(midi)
                                            }
                                            return nil
                                        }
                                        Task {
                                            await Utils.MidiPlayer.shared.playNotes(notes, preset: preset)
                                        }
                                        try? await Task.sleep(nanoseconds: tempo)
                                    } else if part.text == "." {
                                        try? await Task.sleep(nanoseconds: tempo)
                                    } else {
                                        /// Something must be done or else the task will never cancel
                                        try? await Task.sleep(nanoseconds: 1)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
