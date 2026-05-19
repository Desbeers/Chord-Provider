//
//  Utils+MidiPlayer+tab.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore
import CFluidSynth

extension Utils.MidiPlayer {

    /// Start the tab
    func startTab() {
        /// Stop any other grid or tab task
        stopGrid()
        stopTab()
        if self.metronomeTask != nil {
            /// Restart the metronome so it is in sync
            startMetronome()
        }
        tabTask = Task { [weak self] in
            await self?.playTab()
        }
    }

    /// Stop the tab
    func stopTab() {
        tabTask?.cancel()
        tabTask = nil
    }

    /// Play the chords of the grid
    private func playTab() async {
        if let tabs = self.tabs {
            while !Task.isCancelled {
                for tab in tabs {
                    let baseMidi = tab.instrument.tuning.reversed().map(\.midi)
                    let stringOffset = max(0, tab.events.count - tab.instrument.strings.count)
                    let tempo = 60.0 / (Double(metronomeBPM)) / 2
                    var notes: [Int] = []
                    var slides: [Int] = []
                    let hasTransition = tab.events.map(\.content).contains(where: \.hasTransition)
                    let hasPlayableItem = tab.events.map(\.content).contains(where: \.hasPlayableItem)
                    for event in tab.events {
                        let midi = baseMidi[safe: event.line - stringOffset]
                        if !Task.isCancelled, let midi {
                            switch event.content {
                            case .rest:
                                break
                            case .text:
                                break
                            case .barLine:
                                break
                            case .fret(let fret):
                                notes.append((fret + midi))
                                if hasTransition {
                                    /// There is a transition in the column, keep this note when playing the slide
                                    /// - Note: Sounds very fake...
                                    slides.append((fret + midi))
                                }
                            case let .transition(from, to, _):
                                notes.append((from + midi))
                                slides.append((to + midi))
                            }
                        }
                    }
                    /// Play first note
                    if !notes.isEmpty {
                        let notes = notes
                        Task {
                            await Utils.MidiPlayer.shared.playNotes(notes, preset: preset, strum: .down)
                        }
                        self.currentMidiID = tab.columnID
                    }
                    /// Wait after playing a note or a rest
                    if hasPlayableItem {
                        try? await Task.sleep(for: .seconds(tempo))
                    }
                    /// Play optional slide
                    if !slides.isEmpty {
                        let notes = slides
                        Task {
                            await Utils.MidiPlayer.shared.playNotes(notes, preset: preset, strum: .down)
                        }
                        try? await Task.sleep(for: .seconds(tempo))
                    }
                }
            }

        }
    }
}
