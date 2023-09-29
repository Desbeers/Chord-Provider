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
    /// Pinch to zoom gesture
    var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                let newScale = scale * value
                if 0.8...2.0 ~= newScale {
                    scale = newScale
                }
            }
    }
    /// The body of the `View`
    var body: some View {
        VStack {
            ScrollView {
                ViewThatFits {
                    Song.Render(song: song, scale: scale, style: .asGrid)
                    Song.Render(song: song, scale: scale, style: .asList)
                }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
#if os(visionOS)
                    .toolbar {
                        ToolbarItemGroup(placement: .topBarTrailing) {
                            Image(systemName: "magnifyingglass")
                            ToolbarView.ScaleSlider()
                                .frame(width: 100)
                        }
                    }
#else
                    .gesture(magnificationGesture)
#endif

                    .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
