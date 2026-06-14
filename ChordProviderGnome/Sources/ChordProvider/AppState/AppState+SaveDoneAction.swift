//
//  AppState+SaveDoneAction.swift
//  ChordProvider
//
//  © 2026 Nick Berendsen
//

extension AppState {

    /// The action after a song is saved
    enum SaveDoneAction {
        /// Close the window
        case closeWindow
        /// Show the welcome view
        case showWelcomeView
        /// Do nothing
        case noAction
    }
}
