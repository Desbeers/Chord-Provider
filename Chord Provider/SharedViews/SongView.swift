//
//  SongView.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// The Song View
struct SongView: View {
    /// The ``Song``
    let song: Song
    /// Bool to show the chords or not
    @AppStorage("showChords") var showChords: Bool = true
    /// Bool to show the editor or not
    @SceneStorage("showEditor") var showEditor: Bool = false
    /// The scale factor of the `View`
    @SceneStorage("scale") var scale: Double = 1.2
    /// Pinch to zoom
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
        HStack(spacing: 0) {
            ScrollView {
                SongRenderView(song: song, scale: scale)
                    .gesture(magnificationGesture)
                    .background {
                        RoundedRectangle(cornerRadius: 6 * scale, style: .continuous)
                            .fill(.ultraThinMaterial)
                            .shadow(radius: 2)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            if showChords && !showEditor {
                ChordsView(song: song)
                    .transition(.opacity)
            }
        }
    }
}
