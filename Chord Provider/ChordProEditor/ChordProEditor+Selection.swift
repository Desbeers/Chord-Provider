//
//  ChordProEditor+Selection.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension  ChordProEditor {

    /// The current state of selection in the editor
    enum Selection: String {
        /// There is no selection in the editor
        case noSelection
        /// There is a single selection in trhe editor
        case singleSelection
        /// There are multiple selections in the editor
        /// - Note: Not used, I don't know how to get multiple selections with TextKit 2
        case multipleSelections
    }
}
