//
//  DebugView+functions.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension DebugView {

    func getSource() async {
        if let song = appState.song {
            var source: [(line: Int, source: Song.Section.Line)] = []
            for line in song.sections.flatMap(\.lines) {
                source.append((line: line.sourceLineNumber, source: line))
            }
            self.source = source
        } else {
            self.source = []
        }
    }
}
