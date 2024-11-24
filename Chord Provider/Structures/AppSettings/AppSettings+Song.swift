//
//  AppSettings+Song.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension AppSettings {

    struct Song: Codable, Equatable {
        var display = SongDisplayOptions()
        var diagram = DiagramDisplayOptions()
    }
}
