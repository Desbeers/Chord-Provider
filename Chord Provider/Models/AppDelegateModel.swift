//
//  AppDelegateModel.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

/// The application delegate for **Chord Provider**
final class AppDelegateModel: NSObject, NSApplicationDelegate, NSWindowDelegate {

    /// Don't terminate when the last **Chord Provider** window is closed
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
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
        case exportFolderView = "Export Songs"
        /// The ``ChordsDatabaseView``
        case chordsDatabaseView = "Chords Database"
        /// The ``DebugView``
        case debugView = "Debug"
    }
}
