//
//  DatabaseState+SaveDoneAction.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

extension DatabaseState {

    /// The action after an instrument is saved
    enum SaveDoneAction {
        /// Close the window
        case closeWindow
        /// Switch instrument to the new selection
        case switchInstrument
        /// Use the instrument
        /// - Note: Used when saving a database
        case useInstrument
        /// Import an instrument database
        case importDatabase
        /// Do nothing
        case doNothing
    }
}
