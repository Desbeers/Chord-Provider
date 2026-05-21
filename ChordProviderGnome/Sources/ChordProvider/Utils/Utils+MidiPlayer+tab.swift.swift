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
        currentMidiID = -1
        tabTask?.cancel()
        tabTask = nil
    }

    /// Play the notes of the tab
    private func playTab() async {
        if let tabs = self.tabs {
            while !Task.isCancelled {
                for tab in tabs {
                    let tempo = 60.0 / (Double(metronomeBPM)) / 2
                    var notes: [Utils.MidiPlayer.PlaybackNote] = []
                    let hasPlayableItem = tab.events.map(\.content).contains(where: \.hasPlayableItem)
                    for (index, event) in tab.events.reversed().enumerated() {
                        if !Task.isCancelled {
                            switch event.content {
                            case .rest:
                                break
                            case .text:
                                break
                            case .barLine:
                                break
                            case let .fret(_, fret):
                                notes.append(.init(string: index, note: fret, articulation: .normal))
                            case let .transition(_, from, to, transition):
                                notes.append(.init(string: index, note: from, articulation: .transit(to: to, by: transition)))
                            }
                        }
                    }
                    /// Play the notes
                    if !notes.isEmpty {
                        /// Capture the notes
                        let notes = notes
                        Task {
                            await Utils.MidiPlayer.shared.playNotes(notes, strum: .down)
                        }
                        self.currentMidiID = tab.columnID
                    }
                    /// Wait after playing a note or a rest
                    if hasPlayableItem {
                        try? await Task.sleep(for: .seconds(tempo))
                    }
                }
            }

        }
    }
}
