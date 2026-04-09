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
        case useInstrument
        /// Import an instrument database
        case importDatabase
        /// Make a new database
        case newDatabase
        /// Do nothing
        case doNothing
    }
}
