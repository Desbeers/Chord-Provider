//
//  ChordDefinition+Status+color.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension ChordDefinition.Status {

    /// The color for a label
    var color: Color {
        switch self {
        case .correct:
            Color.accentColor
        case .wrongBassNote:
            Color.red
        case .wrongRootNote:
            Color.purple
        case .wrongNotes:
            Color.red
        case .wrongFingers, .missingFingers:
            Color.brown
        default:
            Color.primary
        }
    }
}
