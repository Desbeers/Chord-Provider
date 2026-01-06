//
//  Song+extensions.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import ChordProviderCore

extension Song {
    
    /// The tooltip for the transpose toggle button
    var transposeTooltip: String {
        var text = "Transpose"
        if self.transposing == 0 {
            text += " the song"
        } else {
            text += " by \(self.transposing) semitones"
        }
        return text
    }
}

extension Song {

    /// The intentional name of the song file
    func initialName(format: ChordProviderSettings.Export.Format) -> String {
        var name = settings.fileURL?.deletingPathExtension().lastPathComponent ?? "\(metadata.artist) - \(metadata.title)"
        /// Add the extension
        name.append(".\(format.rawValue)")
        return name
    }
}
