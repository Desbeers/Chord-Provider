//
//  HtmlView.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 23/08/2025.
//

import SwiftUI
import ChordProviderCore
import ChordProviderHTML

struct HtmlView: View {
    let output: String
    init(song: Song, settings: AppSettings) {

        let settings = ChordProviderSettings(
            instrument: settings.display.instrument,
            lyricOnly: settings.application.lyricsOnly,
            repeatWholeChorus: settings.application.repeatWholeChorus
        )
        self.output = HtmlRender.render(song: song, settings: settings)
    }
    var body: some View {
        VStack {
            WKWebRepresentedView(html: output)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
