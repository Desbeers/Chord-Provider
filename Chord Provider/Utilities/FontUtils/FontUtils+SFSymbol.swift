//
//  FontUtils+SFSymbol.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension FontUtils {

    /// Type-safe SF Symbols
    enum SFSymbol: String {
        /// The *capo* icon
        case capo = "paperclip"
        /// The *instrument* icon
        case instrument = "guitars"
        /// The *key* icon
        case key = "key"
        /// The *tempo* icon
        case tempo = "metronome"
        /// The *time* icon
        case time = "timer"
        /// The *comment* icon
        case comment = "text.bubble"
        /// The *repeat chorus* icon
        case repeatChorus = "arrow.trianglehead.2.clockwise.rotate.90"
        /// The *tag* icon
        case tag = "tag"
    }
}
