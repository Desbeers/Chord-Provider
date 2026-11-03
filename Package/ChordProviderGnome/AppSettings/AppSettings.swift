//
//  AppSettings.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation
import ChordProviderCore
import SourceView

/// The settings for **Chord Provider**
struct AppSettings: Codable, Equatable {

    /// Application settings
    var app = App()
    /// Core settings
    var core = ChordProviderSettings()
    /// The theme settings
    var theme = Theme()
    /// The editor settings
    var editor = SourceViewOptions()
    /// The position of the splitter
    var splitter: Int = 400
    /// Bool if the editor is shown
    var showEditor: Bool = false
}
