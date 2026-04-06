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
    mutating func openSample(_ sample: Utils.Samples, showEditor: Bool) {
        if
            let sampleSong = Bundle.module.url(
                forResource: "Samples/Songs/\(sample.rawValue)",
                withExtension: "chordpro"
            ),
            let content = try? String(contentsOf: sampleSong, encoding: .utf8) {
            editor.coreSettings.fileURL = nil
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
            editor.coreSettings.fileURL = fileURL
            openSong(content: content, showEditor: settings.editor.showEditor)
            scene.toastMessage = "Opened \(fileURL.deletingPathExtension().lastPathComponent)"
        } catch {
            editor.coreSettings.fileURL = nil
            scene.toastMessage = "Could not open the song"
        }
    }

    /// Open a song with its content as string
    /// - Parameters:
    ///   - content: The content of the song
    ///   - showEditor: Bool to show the editor
    ///   - templateURL: The optional template URL of the song
    mutating private func openSong(content: String, showEditor: Bool, templateURL: URL? = nil) {
        /// Reset transpose
        editor.coreSettings.transpose = 0
        editor.song.metadata.transpose = 0
        /// Don't show the previous song because the rendering has some delay
        editor.song.hasContent = false
        /// - Note: Never set the content directly; it will be ignored and the song will not be updated
        editor.command = .replaceAllText(text: content)
        scene.originalContent = content
        settings.editor.showEditor = showEditor
        if let templateURL {
            editor.coreSettings.templateURL = templateURL
        }
        /// Close the welcome `View`
        scene.showWelcomeView = false
    }
}
