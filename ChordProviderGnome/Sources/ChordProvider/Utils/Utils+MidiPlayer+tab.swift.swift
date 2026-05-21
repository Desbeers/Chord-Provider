//
//  Utils+MidiPlayer+tab.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension Utils.MidiPlayer {

    /// Start the tab
    func startTab() async {
        guard let tabs = snapshot.tabs else {
            /// There are no tabs to play
            /// - Note: This should not happen...
            return
        }
        /// Stop any other grid or tab task
        stopGrid()
        stopTab()
        /// Wait for the first accent
        while !transport.isAccent {
            try? await Task.sleep(for: .milliseconds(1))
        }
        /// Play the tab
        playbackTasks.tab = Task {
            await playTabs(tabs)
        }
    }

    /// Stop the tab
    func stopTab() {
        setCurrentMidiID(-1)
        playbackTasks.tab?.cancel()
        playbackTasks.tab = nil
    }

    /// Play the notes of the tabs
    private func playTabs(_ tabs: [Song.Section.Line.Tab]) async {
        /// The pulse counter
        /// - Note: I use subdivisions here because of 'rest' notes in the tablature
        var lastSubdivision = -1
        /// Loop the tabs until the task is canceled
        while !Task.isCancelled {
            for tab in tabs {
                var notes: [Utils.MidiPlayer.PlaybackNote] = []
                let hasPlayableItem = tab.events.contains { $0.content.hasPlayableItem }
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
                    setCurrentMidiID(tab.columnID)
                    await playNotes(notes, strum: .down)
                }
                /// Wait after playing a note or a rest when the item was playable
                /// - Note: A *rest* is also a *playable* item
                if hasPlayableItem {
                    lastSubdivision = transport.subdivision
                    while transport.subdivision == lastSubdivision {
                        try? await Task.sleep(for: .milliseconds(1))
                    }
                }
            }
        }
    }
}
