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
    struct Scene {
        /// The original source of the song when opened or created
        /// - Note: To check if the song is changed
        var originalSource = ""
        /// A signal to open a song
        var openSong = Signal()
        /// A signal to save as song with a new name
        var saveSongAs = Signal()
        /// A signal to open a folder
        var openFolder = Signal()
        /// What to do when a song is saved
        var saveDoneAction: SaveDoneAction = .noAction
        /// Show the *About* dialog
        var showAboutDialog = false
        /// Show the *Transpose* dialog
        var showTransposeDialog = false
        /// Bool if the welcome is shown
        var showWelcome: Bool = true
        /// Show the *Debug*
        var showDebug = false
        /// The selected debug tab
        var selectedDebugTab: Views.Debug.Tab = .log
        /// Bool if the preferences is shown
        var showPreferences: Bool = false
        /// Bool if the close dialog is shown
        var showDirtyClose: Bool = false
        /// Bool to show the keyboard shortcuts
        var showKeyboardShortcuts: Bool = false
        /// Show a toast
        var showToast = Signal()
        /// The toast message
        var toastMessage: String = ""
    }
}
