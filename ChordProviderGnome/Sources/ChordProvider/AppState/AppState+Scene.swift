//
//  AppState+Scene.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import SourceView

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

        // MARK: Signals

        /// A signal to open a song
        var openSong = Signal()
        /// A signal to save as song with a new name
        var saveSongAs = Signal()
        /// A signal to open a folder
        var openFolder = Signal()
        /// What to do when a song is saved
        var saveDoneAction: SaveDoneAction = .noAction

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
        var showShortcutsDialog: Bool = false
        /// Show the *Define chord* dialog
        var showDefineChordDialog: Bool = false

        // MARK: Toasts

        /// Show a toast
        var showToast = Signal()
        /// The toast message
        var toastMessage: String = ""
    }
}
