//
//  SongView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for the song
struct SongView: View {
    /// The ``Song``
    let song: Song
    /// Max width of the `View`
    @State private var maxWidth: Double = 340
    /// The body of the `View`
    var body: some View {
        ZStack {
            /// Get the size of the longest song line
            /// - Note: This is not perfect but seems well enough for normal songs
            RenderView2.PartsView(
                parts: song.metadata.longestLine.parts ?? [],
                settings: song.settings
            )
            .onGeometryChange(for: CGSize.self) { proxy in
                proxy.size
            } action: { newValue in
                maxWidth = newValue.width > 340 ? newValue.width : 340
            }
            .hidden()
            VStack {
                switch song.settings.display.paging {
                case .asList:
                    ScrollView {
                        /// - Note: Try if a *grid* label will fit; else show it inline
                        ViewThatFits {
                            RenderView2.MainView(
                                song: song,
                                labelStyle: .grid,
                                maxWidth: maxWidth
                            )
                            RenderView2.MainView(
                                song: song,
                                labelStyle: .inline,
                                maxWidth: maxWidth
                            )
                        }
                        .padding(song.settings.scale * 20)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                case .asColumns:
                    RenderView2.MainView(
                        song: song,
                        labelStyle: .inline,
                        maxWidth: maxWidth
                    )
                }
            }
            .contentShape(Rectangle())
            .scaleModifier
        }
        /// Set the standard scaled font
        .font(song.settings.style.fonts.text.swiftUIFont(scale: song.settings.scale))
    }
}
