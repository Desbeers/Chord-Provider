//
//  ChordProviderSettings.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

public struct ChordProviderSettings {
    public init(options: ChordProviderSettings.Options = .init()) {
        self.options = options
    }
    public var options: Options = .init()
}

extension ChordProviderSettings {

    public struct Options {
        public init(lyricOnly: Bool = false) {
            self.lyricOnly = lyricOnly
        }

        public var lyricOnly: Bool = false
    }
}
