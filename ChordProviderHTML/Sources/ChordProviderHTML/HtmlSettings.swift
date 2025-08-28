//
//  HtmlSettings.swift
//  ChordProviderHTML
//
//  © 2025 Nick Berendsen
//

import Foundation

public struct HtmlSettings {
    public init(options: HtmlSettings.Options = .init()) {
        self.options = options
    }
    public var options: Options = .init()
}

extension HtmlSettings {

    public struct Options {
        public init(lyricOnly: Bool = false) {
            self.lyricOnly = lyricOnly
        }

        public var lyricOnly: Bool = false
    }
}
