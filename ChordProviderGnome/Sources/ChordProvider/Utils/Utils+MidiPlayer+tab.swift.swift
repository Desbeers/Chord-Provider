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
    func startTab(instrument: Instrument) {
        /// Stop any other grid or tab task
        stopGrid()
        stopTab()
        if self.metronomeTask != nil {
            /// Restart the metronome so it is in sync
            startMetronome(instrument: instrument)
        }
        tabTask = Task { [weak self] in
            await self?.playTab(instrument: instrument)
        }
    }

    /// Stop the tab
    func stopTab() {
        tabTask?.cancel()
        tabTask = nil
    }

    /// Play the chords of the grid
    private func playTab(instrument: Instrument) async {
        let baseMidi = instrument.tuning.reversed().map(\.midi)
        if let tabs = self.tabs {
            while !Task.isCancelled {
                for tab in tabs {
                    let tempo = 60.0 / (Double(metronomeBPM)) / 2
                    var notes: [Int] = []
                    var slides: [Int] = []
                    let hasSlide = tab.events.map(\.content).contains(where: \.hasSlide)
                    let hasPlayableItem = tab.events.map(\.content).contains(where: \.hasPlayableItem)
                    for event in tab.events {
                        let midi = baseMidi[safe: event.string] ?? 40
                        if !Task.isCancelled {
                            switch event.content {
                            case .rest:
                                break
                            case .text(let text):
                                break
                            case .barLine:
                                break
                            case .fret(let fret):
                                notes.append((fret + midi))
                                if hasSlide {
                                    /// There is a slide in the column, keep this note when playing the slide
                                    /// - Note: Sounds very fake...
                                    slides.append((fret + midi))
                                }
                            case let .slide(from, to, direction):
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
                        self.currentMidiID = tab.tick
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
