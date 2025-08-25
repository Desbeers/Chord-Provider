//
//  ChordPro+LogMessage.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import ChordProviderCore

extension LogUtils.Level {
    /// The SwiftUI `Color` for the level of the log
    var color: Color {
        switch self {
        case .debug:
            Color.indigo
        case .info:
            Color.mint
        case .notice:
            Color.blue
        case .error:
            Color.red
        case .fault:
            Color.orange
        case .warning:
            Color.orange
        @unknown default:
            Color.primary
        }
    }
}
