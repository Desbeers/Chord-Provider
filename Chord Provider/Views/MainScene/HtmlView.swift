//
//  HtmlView.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 23/08/2025.
//

import SwiftUI
import ChordProviderCore
import ChordProviderHTML

public struct HtmlView: View {
    let song: Song
    let output: String
    public init(song: Song, lyricsOnly: Bool) {

        var settings = HtmlSettings()
        settings.options.lyricOnly = lyricsOnly

        self.song = song
        self.output = HtmlRender.render(song: song, settings: settings)
    }
    public var body: some View {
        VStack {
            WKWebRepresentedView(html: output)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
