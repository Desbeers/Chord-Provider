//
//  File.swift
//  ChordProvider
//
//  Created by Nick Berendsen on 04/09/2025.
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
    init(_ text: String, font: AppSettings.Font, zoom: Double) {

        let wrapper = "<span font='\(font.size(zoom: zoom))'>\(text)</span>"

        self.init(label: wrapper)
    }
}
