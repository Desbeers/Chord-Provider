//
//  AppState+SaveDoneAction.swift
//  ChordProvider
//
//  Created by Nick Berendsen on 06/01/2026.
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
