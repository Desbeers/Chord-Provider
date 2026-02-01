//
//  AppState+SaveDoneAction.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
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
