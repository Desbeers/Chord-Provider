//
//  SongView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

/// SwiftUI `View` for the song
struct SongView: View {
    /// The app state
    @Environment(AppState.self) private var appState
    /// The scene state
    @Environment(SceneState.self) private var sceneState
    /// Chord Display Options
    @Environment(ChordDisplayOptions.self) private var chordDisplayOptions
    /// The minimum scale factor
    private let minScale: Double = 0.8
    /// The maximum scale factor
    private let maxScale: Double = 2.6
    /// Observe the gesture state
    @GestureState private var magnificationState = MagnificationState.inactive
    /// State of the `MagnificationGesture`
    private enum MagnificationState {
        /// No magnification
        case inactive
        /// Magnification ongoing
        case active(scale: Double)
        /// The current scale factor
        var scale: Double {
            switch self {
            case .active(let scale): scale
            default: 1.0
            }
        }
    }
    /// Calculate the scale within the minimum and maximum scale value
    private var scale: Double {
        min(max(sceneState.currentScale * magnificationState.scale, minScale), maxScale)
    }
    /// The `MagnifyGesture`
    private var magnifyGesture: some Gesture {
        MagnifyGesture()
            .updating($magnificationState) { value, state, _ in
                state = .active(scale: value.magnification)
            }
            .onEnded { value in
                sceneState.currentScale = min(max(sceneState.currentScale * value.magnification, minScale), maxScale)
            }
    }
    /// The `TapGesture`
    private var doubleTapGesture: some Gesture {
        TapGesture(count: 2).onEnded {
            withAnimation {
                sceneState.currentScale = min(max(sceneState.currentScale + 0.2, minScale), maxScale)
            }
        }
    }
    /// The body of the `View`
    var body: some View {
        VStack {
            switch appState.settings.paging {
            case .asList:
                ScrollView {
                    ViewThatFits {
                        Song.Render(
                            song: sceneState.song,
                            options: Song.DisplayOptions(
                                paging: .asList,
                                label: .grid,
                                scale: scale,
                                chords: appState.settings.showInlineDiagrams ? .asDiagram : .asName,
                                midiInstrument: chordDisplayOptions.displayOptions.midiInstrument
                            )
                        )
                        Song.Render(
                            song: sceneState.song,
                            options: Song.DisplayOptions(
                                paging: .asList,
                                label: .inline,
                                scale: scale,
                                chords: appState.settings.showInlineDiagrams ? .asDiagram : .asName,
                                midiInstrument: chordDisplayOptions.displayOptions.midiInstrument
                            )
                        )
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            case .asColumns:
                Song.Render(
                    song: sceneState.song,
                    options: Song.DisplayOptions(
                        paging: .asColumns,
                        label: .inline,
                        scale: scale,
                        chords: appState.settings.showInlineDiagrams ? .asDiagram : .asName,
                        midiInstrument: chordDisplayOptions.displayOptions.midiInstrument
                    )
                )
            }
        }
        .contentMargins(.all, scale * 20, for: .scrollContent)
        .animation(.default, value: appState.settings.showInlineDiagrams)
        .contentShape(Rectangle())
        .gesture(ExclusiveGesture(magnifyGesture, doubleTapGesture))
        .onLongPressGesture(minimumDuration: 1) {
            withAnimation {
                sceneState.currentScale = min(max(sceneState.currentScale - 0.2, minScale), maxScale)
            }
        }
    }
}
