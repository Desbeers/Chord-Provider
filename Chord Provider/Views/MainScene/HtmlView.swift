//
//  HtmlView.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 23/08/2025.
//

import SwiftUI
import ChordProviderCore
import ChordProviderHTML

/// SwiftUI `View` for the HTML rendering
struct HtmlView: View {
    let output: String
    init(song: Song, settings: AppSettings) {

        let settings = ChordProviderSettings(
            instrument: settings.core.instrument,
            lyricsOnly: settings.core.lyricsOnly,
            repeatWholeChorus: settings.core.repeatWholeChorus
        )
        self.output = HtmlRender.render(song: song, settings: settings)
    }
    var body: some View {
        VStack {
            AppKitUtils.WKWebRepresentedView(html: output)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
