//
//  AppState+open.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation
import ChordProviderCore
import ChordProviderMIDI

extension AppState {

    /// Open a sample song from the application bundle.
    /// - Parameter sample: The sample song.
    mutating func openSample(_ sample: Utils.Samples, showEditor: Bool) {
        guard let sampleSong = Bundle.module.url(
            forResource: "Samples/Songs/\(sample.rawValue)",
            withExtension: "chordpro")
        else {
            /// This should never happen, it is internal code.
            return
        }
        openSong(fileURL: sampleSong, showEditor: true, templateURL: sampleSong)
    }

    /// Open a song from an URL.
    /// - Parameter fileURL: The song URL to open.
    mutating func openSong(fileURL: URL) {
        openSong(fileURL: fileURL, showEditor: settings.showEditor)
    }

    /// Open a song.
    /// - Parameters:
    ///   - fileURL: The URL of the file.
    ///   - showEditor: Bool to show the editor.
    ///   - templateURL: The template URL of the song.
    mutating private func openSong(
        fileURL: URL,
        showEditor: Bool,
        templateURL: URL? = nil
    ) {
        settings.showEditor = showEditor
        if let templateURL {
            settings.core.templateURL = templateURL
        }
        // Search must be closed
        editor.showSearchBar = false
        // Reset transpose
        settings.core.transpose = 0
        // Don't show the previous song because the rendering has some delay
        song.hasContent = false
        song.id = UUID()
        controller.command(.open(fileURL))
    }

    /// Open the Main View with the song.
    ///
    /// This function will be called by the 'onOpen' and 'onNew' callbacks when
    /// a song is succesfully opened or created from a template.
    mutating func openMainView() {
        // Set a new random song for the Home `View`
        setRandomSong()
        // Close the Home `View`
        scene.viewStatus = .openingSong
        // Start the MIDI player transport
        Task { @concurrent in
            await ChordProviderMIDI.shared.startTransport()
        }
    }
}
