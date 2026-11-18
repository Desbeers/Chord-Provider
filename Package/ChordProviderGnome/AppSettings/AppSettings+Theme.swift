//
//  AppSettings+Theme.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation
import SourceEditor
import CAdw

extension AppSettings {

    /// Settings for the theme
    struct Theme: Codable, Equatable {

        /// The zoom factor of the Render `View`
        var zoom: Double = 1
        /// The font size of the editor
        var editorFontSize: Int = 100
        /// The font size for chords
        var chordsFontSize: Int = 100
    }
}
