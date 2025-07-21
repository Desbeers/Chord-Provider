//
//  Samples.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 06/06/2025.
//

import Foundation

/// Sample song and theme files in the package
enum Samples: String {
    case help = "Help"
    case markdown = "Markdown"
    case debugTextblock = "DebugTextblock"
    case debugWarnings = "DebugWarnings"
    case mollyMalone = "Molly Malone"
    case swingLowSweetChariot = "Swing Low Sweet Chariot"

    case olympicWhite = "Olympic White"
    case totalChaos = "Total Chaos"
    case aGreenDay = "A Green Day"
    case deliciousDonuts = "Delicious Donuts"

    static var debug: [Samples] {
        [
            .debugTextblock,
            .debugWarnings
        ]
    }

    static var theme: [Samples] {
        [
            .olympicWhite,
            .totalChaos,
            .aGreenDay,
            .deliciousDonuts
        ]
    }
}
