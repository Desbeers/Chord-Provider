//
//  ChordProEditor+Selection.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 07/05/2024.
//

import Foundation

extension  ChordProEditor {

    enum Selection: String {
        /// There is no selection in the editor
        case none
        /// There is a single selection in trhe editor
        case single
        /// There are multiple selections in the editor
        case multiple
    }
}
