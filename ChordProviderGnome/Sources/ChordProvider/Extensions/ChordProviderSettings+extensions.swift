//
//  ChordProviderSettings+extensions.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import ChordProviderCore

extension ChordProviderSettings {
    
    /// Group settings into one label
    var settingsLabel: String {
        var label: [String] = [self.instrument.description]
        if self.lyricsOnly {
            label.append("Lyrics only")
        }
        if self.repeatWholeChorus {
            label.append("Repeat whole chorus")
        }
        return label.joined(separator: ", ")
    }
}
