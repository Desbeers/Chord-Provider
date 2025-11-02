//
//  RenderView.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore
import ChordProviderHTML

/// The `View` for the rendered song
struct RenderView: View {

    let song: Song
    let settings: AppSettings

    var view: Body {
        HStack {
            ScrollView {
                GtkRender.PageView(song: song, settings: settings)
            }
            Separator()
            if !song.chords.isEmpty {
                ChordsView(song: song, settings: settings)
                    .frame(minWidth: 100)
                    .transition(.coverLeftRight)
            }

        }
    }
}
