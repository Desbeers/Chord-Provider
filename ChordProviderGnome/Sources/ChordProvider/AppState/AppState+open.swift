//
//  AppState+open.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension AppState {

    /// Open a sample song from the application bundle
    /// - Parameters:
    ///   - sample: The sample song
    ///   - showEditor: Bool to show the editor
    mutating func openSample(_ sample: String, showEditor: Bool) {
        if
            let sampleSong = Bundle.module.url(forResource: "Samples/Songs/\(sample)", withExtension: "chordpro"),
            let content = try? String(contentsOf: sampleSong, encoding: .utf8) {
            self.editor.song.settings.fileURL = nil
            openSong(content: content, showEditor: showEditor, templateURL: sampleSong)
        } else {
            print("Error loading sample song")
        }
    }

    /// Open a song from an URL
    /// - Parameter fileURL: The song URL to open
    mutating func openSong(fileURL: URL) {
        do {
            let content = try SongFileUtils.getSongContent(fileURL: fileURL)
            self.editor.song.settings.fileURL = fileURL
            openSong(content: content, showEditor: self.settings.editor.showEditor)
            self.scene.toastMessage = "Opened \(fileURL.deletingPathExtension().lastPathComponent)"
            self.addRecentSong()
        } catch {
            self.scene.toastMessage = "Could not open the song"
        }
    }

    /// Open a song with its content as string
    /// - Parameters:
    ///   - content: The content of the song
    ///   - showEditor: Bool to show the editor
    ///   - templateURL: The optional template URL of the song
    mutating private func openSong(content: String, showEditor: Bool, templateURL: URL? = nil) {
        /// Reset transpose
        self.editor.song.settings.transpose = 0
        self.editor.song.metadata.transpose = 0
        /// Don't show the previous song because the rendering has some delay
        self.editor.song.hasContent = false
        /// - Note: Never set the content directly; it will be ignored and the song will not be updated
        self.editor.command = .replaceAllText(text: content)
        self.scene.originalContent = content
        self.settings.editor.showEditor = showEditor
        if let templateURL {
            self.editor.song.settings.templateURL = templateURL
        }
        /// Close the welcome `View`
        self.scene.showWelcomeView = false
    }
}
