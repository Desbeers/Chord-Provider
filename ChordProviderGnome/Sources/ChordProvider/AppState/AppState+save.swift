//
//  AppState+save.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension AppState {

    /// Save a song to disk
    /// - Parameter song: The `Song` to save
    mutating func saveSong(_ song: Song) {
        if let fileURL = self.editor.song.settings.fileURL {
            try? self.editor.song.content.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
            /// Remember the content as  saved
            self.scene.originalContent = self.editor.song.content
            /// Add it to the recent songs list
            self.addRecentSong()
        } else {
            /// The song is never saved before; open the *Save as* dialog
            self.scene.saveSongAs.signal()
        }
    }

}
