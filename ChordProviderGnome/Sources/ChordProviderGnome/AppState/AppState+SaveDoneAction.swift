//
//  AppState+SaveDoneAction.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

extension AppState {

    /// The action after a song is saved
    enum SaveDoneAction {
        /// Close the window
        case closeWindow
        /// Show the home view
        case showHomeView
        /// Do nothing
        case noAction
    }
}
