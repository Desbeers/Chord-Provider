//
//  Samples.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 06/06/2025.
//

import Foundation

enum Samples: String {
    case help = "Help"
    case markdown = "Markdown"
    case debugTextblock = "DebugTextblock"
    case debugWarnings = "DebugWarnings"
    case mollyMalone = "Molly Malone"
    case swingLowSweetChariot = "Swing Low Sweet Chariot"

    static var debug: [Samples] {
        [
            .debugTextblock,
            .debugWarnings
        ]
    }
}
