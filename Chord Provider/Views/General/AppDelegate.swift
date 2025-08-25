//
//  AppDelegate.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import ChordProviderCore

/// The application delegate for **Chord Provider**
final class AppDelegate: NSObject, NSApplicationDelegate {

    /// Don't terminate when the last **Chord Provider** window is closed
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }

    /// Cleanup the temporarily files on exit
    func applicationWillTerminate(_ notification: Notification) {
        try? FileManager.default.removeItem(at: Song.temporaryDirectoryURL)
    }

    // MARK: App Window ID's

    /// The windows we can open
    enum WindowID: String {
        /// The ``WelcomeView``
        case welcomeView = "Chord Provider"
        /// The ``AboutView``
        case aboutView = "About Chord Provider"
        /// The ``MediaPlayerView
        case mediaPlayerView = "Chord Provider Media"
        /// The ``ExportFolderView``
        case exportFolderView = "Export Songs Folder to PDF"
        /// The ``ChordsDatabaseView``
        case chordsDatabaseView = "Chords Database"
        /// The ``DebugView``
        case debugView = "Debug Info"
        /// The ``HelpView``
        case helpView = "Chord Provider Help"
        /// The ``C64View``
        case c64View = "Commodore 64"
    }
}
