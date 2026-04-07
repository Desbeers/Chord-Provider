//
//  AppState+Scene.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore
import Adwaita

extension AppState {

    /// Settings for the current scene
    /// - Note: These settings are not saved
    struct Scene {

        /// Show the *Welcome* view
        var showWelcomeView: Bool = true
        /// The selected debug tab
        var selectedDebugTab: Views.Debug.Tab = .log
        /// The selected debug json section
        var selectedDebugJSONSection: Views.Debug.JSONPage = .metadata
        /// The original content of the song when opened or created
        /// - Note: To check if the song is changed
        var originalContent = ""
        /// What to do when a song is saved
        var saveDoneAction: SaveDoneAction = .noAction

        // MARK: Signals

        /// A signal to open a song
        var openSong = Signal()
        /// A signal to save as song with a new name
        var saveSongAs = Signal()
        /// A signal to open a folder
        var openFolder = Signal()
        /// A signal to import a chords database
        var importDatabase = Signal()

        // MARK: Dialogs

        /// Show the *About* dialog
        var showAboutDialog = false
        /// Show the *Transpose* dialog
        var showTransposeDialog = false
        /// Show the *Debug* dialog
        var showDebugDialog = false
        /// Show the *Preferences* dialog
        var showPreferencesDialog: Bool = false
        /// Show the *Close* dialog
        /// - Note: It will be shown when the content of the song is modified
        var showCloseDialog: Bool = false
        /// Show the *Shortcuts* dialog
        /// - Note: Shortcuts don't work on macOS
        var showShortcutsDialog: Bool = false

        // MARK: Errors

        // The error
        private(set) var error: ChordProviderError?
        /// Show an error dialog for the main window
        var showMainErrorDialog: Bool = false
        /// Show an error dialog for the database window
        var showDatabaseErrorDialog: Bool = false

        // MARK: Toasts

        /// Show a toast
        var showToast = Signal()
        /// The toast message
        var toastMessage: String = ""

        // MARK: MIDI

        /// Play metronome
        var playMetronome: Bool = false
        /// Play grid chords
        var gridChordsID: Int = -1
    }
}

extension AppState.Scene {

    /// Throw an error and open a dialog
    /// - Parameters:
    ///   - error: The error
    ///   - main: Bool if the error should be attached to the main window
    mutating func throwError(error: ChordProviderError, main: Bool) {
        self.error = error
        /// Show the error dialog
        if main {
            showMainErrorDialog = true
        } else {
            showDatabaseErrorDialog = true
        }
    }
}