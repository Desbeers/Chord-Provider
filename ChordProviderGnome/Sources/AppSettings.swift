//
//  File.swift
//  ChordProvider
//
//  Created by Nick Berendsen on 01/09/2025.
//

import Foundation
import ChordProviderCore
import Adwaita

struct AppSettings {
    var core = ChordProviderSettings()
    var app = App()
}

extension AppSettings {

    struct App {

        var text = sampleSong
        var showEditor = false
        var openSong = Signal()
        var saveSongAs = Signal()
        var songURL: URL?
        var aboutDialog = false
    }
}
