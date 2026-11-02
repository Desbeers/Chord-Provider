//
//  AppState+save.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension AppState {

    /// Save the current song to disk
    mutating func saveSong() {
        if let fileURL = settings.core.fileURL {
            try? song.content.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
            // Remember the content as  saved
            self.scene.originalContent = song.content
            // Update the song browser
            getFolderContent()
        } else {
            /// The song is never saved before; open the *Save as* dialog
            scene.saveSongAs.signal()
        }
    }
}
