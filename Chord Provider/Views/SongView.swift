//
//  SongView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for the song
struct SongView: View {
    /// The ``Song``
    let song: Song
    /// The scale factor of the `View`
    @SceneStorage("scale") var scale: Double = 1.2
    /// The body of the `View`
    var body: some View {
        VStack {
            ScrollView {
                ViewThatFits {
                    Song.Render(song: song, scale: scale, style: .asGrid)
                    Song.Render(song: song, scale: scale, style: .asList)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            }
        }
        .gesture(
            MagnificationGesture()
                .onChanged { scale in
                    let newScale = self.scale * scale
                    self.scale = min(max(newScale.magnitude, 0.8), 2.0)
                }
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
