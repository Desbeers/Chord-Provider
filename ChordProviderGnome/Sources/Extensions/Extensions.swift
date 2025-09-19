//
//  Extensions.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore
import Adwaita

extension ChordProviderSettings {

    var transposeTooltip: String {
        var text = "Transpose"
        if self.transpose == 0 {
            text += " the song"
        } else {
            text += " by \(self.transpose) semitones"
        }
        return text
    }
}

extension Text {

    /// Initialize a text widget.
    /// - Parameter text: The content.
    /// - Parameter font: The font to use
    /// - Parameter zoom: The current zoom facrtor
    init(_ text: String, font: AppSettings.Font, zoom: Double) {
        /// Wrap the text in `pango`
        let wrapper = "<span \(font.style(zoom: zoom))>\(text)</span>"
        self.init(label: wrapper)
    }
}
