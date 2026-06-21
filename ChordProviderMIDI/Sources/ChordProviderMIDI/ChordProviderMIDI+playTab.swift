//
//  ChordProviderMIDI+playTab.swift
//  ChordProviderMIDI
//
//  © 2026 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension ChordProviderMIDI {

    /// Play the tab
    public func startTab() async {
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
    public func stopTab() {
        setCurrentMidiID(-1)
        playbackTasks.tab?.cancel()
        playbackTasks.tab = nil
    }

    /// Play the notes of the tabs
    private func playTabs(_ tabs: [Song.Section.Line.Tab]) async {
        // Get the total columns
        guard let totalColumns = tabs.compactMap(\.events.last?.column).max() else {
            return
        }
        /// All the columns
        var columns = (0 ..< (totalColumns + 1)).map { item in
            Song.Section.Line.Tab(lineID: item, plain: "")
        }
        // Fill the columns
        for line in tabs where line.events.contains(where: \.content.hasPlayableItem) {
            for event in line.events {
                columns[event.column].events.append(event)
            }
        }
        /// The pulse counter
        /// - Note: I use subdivisions here because of 'rest' notes in the tablature
        var lastSubdivision = -1

        var transitionNote: Int? = nil

        // Loop the tabs until the task is canceled
        while !Task.isCancelled {
            for tab in columns {
                var notes: [ChordProviderMIDI.PlaybackNote] = []
                let hasPlayableItem = playableColumn(tab)
                for (index, event) in tab.events.reversed().enumerated() {
                    if !Task.isCancelled {
                        switch event.content {
                        case .rest:
                            break
                        case .text:
                            break
                        case .barLine:
                            break
                        case let .fret(note):
                            transitionNote = event.transitionNote
                            notes.append(
                                .init(
                                    stringID: index,
                                    transitionNote: transitionNote,
                                    articulation: .normal(note: note)
                                )
                            )
                        case let .transition(transition):
                            notes.append(
                                ChordProviderMIDI.PlaybackNote(
                                    stringID: index,
                                    transitionNote: transitionNote,
                                    articulation: .transition(
                                        ChordPro.Tab.Transition(
                                            from: transition.from,
                                            to: transition.to,
                                            by: transition.technique
                                        )
                                    )
                                )
                            )
                        case .filler:
                            break
                        }
                    }
                }
                // Play the notes
                if !notes.isEmpty {
                    setCurrentMidiID(tab.id)
                    let notes = notes
                    Task {
                        await playNotes(notes, strum: .down)
                    }
                }
                // Wait after playing a note or a rest when the item was playable
                if hasPlayableItem {
                    lastSubdivision = transport.subdivision
                    while transport.subdivision == lastSubdivision {
                        try? await Task.sleep(for: .milliseconds(1))
                    }
                }
            }
        }

        /// Bool if the column has playable items
        /// - Parameter tab: The tab
        /// - Returns: Bool if playable
        func playableColumn(_ tab: Song.Section.Line.Tab) -> Bool {
            guard tab.events.contains(where: { $0.content.hasPlayableItem }) == true else {
                return false
            }
            if tab.events.contains(where: { $0.content.hasFiller }) && !tab.events.contains(where: { $0.content.hasNoteItem })  {
                return false
            }
            return true
        }
    }
}
