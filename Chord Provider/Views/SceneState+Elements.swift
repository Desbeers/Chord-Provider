//
//  SceneState+Elements.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import ChordProShared

extension SceneState {

    // MARK: Chords Menu

    /// Chords menu
    var chordsMenu: some View {
        ChordsMenu(sceneState: self)
    }
    /// Chords menu
    private struct ChordsMenu: View {
        /// The binding to the observable ``SceneState``
        @Bindable var sceneState: SceneState
        /// The body of the `View`
        var body: some View {
            Menu("Chords", systemImage: sceneState.songDisplayOptions.showChords ? "number.circle.fill" : "number.circle") {
                sceneState.showChordsButton
                Divider()
                sceneState.chordsPositionPicker
                    .pickerStyle(.inline)
            }
        }
    }
}

extension SceneState {

    // MARK: Show Chords Button

    /// Show chords button
    var showChordsButton: some View {
        ShowChordsButton(sceneState: self)
    }
    /// Show chords button
    private struct ShowChordsButton: View {
        /// The binding to the observable ``SceneState``
        @Bindable var sceneState: SceneState
        /// The body of the `View`
        var body: some View {
            Button {
                sceneState.songDisplayOptions.showChords.toggle()
            } label: {
                Text(sceneState.songDisplayOptions.showChords ? "Hide Chords" : "Show Chords")
            }
        }
    }
}

extension SceneState {

    // MARK: Chords Position Picker

    /// Chords Position Picker
    var chordsPositionPicker: some View {
        ChordsPositionPicker(sceneState: self)
    }
    /// Chords Position Picker
    private struct ChordsPositionPicker: View {
        /// The binding to the observable ``SceneState``
        @Bindable var sceneState: SceneState
        /// The body of the `View`
        var body: some View {
            Picker("Position:", selection: $sceneState.songDisplayOptions.chordsPosition) {
                ForEach(Song.DisplayOptions.ChordsPosition.allCases, id: \.rawValue) { value in
                    Text(value.rawValue)
                        .tag(value)
                }
            }
            .disabled(sceneState.songDisplayOptions.showChords == false)
        }
    }
}

extension SceneState {

    // MARK: Chords As Diagram Toggle

    /// Chords As Diagram Toggle
    var chordsAsDiagramToggle: some View {
        ChordsAsDiagramToggle(sceneState: self)
    }

    /// Chords As Diagram Toggle
    private struct ChordsAsDiagramToggle: View {
        /// The binding to the observable ``SceneState``
        @Bindable var sceneState: SceneState
        /// The body of the `View`
        var body: some View {
            Toggle(isOn: $sceneState.songDisplayOptions.showInlineDiagrams) {
                Text("Chords as Diagram")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .toggleStyle(.switch)
            .minimumScaleFactor(0.1)
        }
    }
}

extension SceneState {

    // MARK: Song Paging Picker

    /// Song Paging Picker
    var songPagingPicker: some View {
        SongPagingPicker(sceneState: self)
    }
    /// Song Paging Picker
    private struct SongPagingPicker: View {
        /// The binding to the observable ``SceneState``
        @Bindable var sceneState: SceneState
        /// The body of the `View`
        var body: some View {
            Picker("Pager:", selection: $sceneState.songDisplayOptions.paging) {
                ForEach(Song.DisplayOptions.Paging.allCases, id: \.rawValue) { value in
                    value.label
                        .tag(value)
                }
            }
        }
    }
}


extension SceneState {

    // MARK: Scale Slider

    /// Scale Slider
    var scaleSlider: some View {
        ScaleSlider(sceneState: self)
    }
    /// Scale Slider
    private struct ScaleSlider: View {
        /// The binding to the observable ``SceneState``
        @Bindable var sceneState: SceneState
        /// The body of the `View`
        var body: some View {
            Slider(value: $sceneState.currentScale, in: 0.8...2.0) {
                Label("Zoom", systemImage: "magnifyingglass")
            }
            .labelStyle(.iconOnly)
        }
    }
}

extension SceneState {

    // MARK: Show Editor Button

    /// Show Editor Button
    var showEditorButton: some View {
        ShowEditorButton(sceneState: self)
    }
    /// Show Editor Button
    private struct ShowEditorButton: View {
        /// The binding to the observable ``SceneState``
        @Bindable var sceneState: SceneState
        /// The body of the `View`
        var body: some View {
            Toggle(isOn: $sceneState.showEditor) {
                Label("Edit", systemImage: sceneState.showEditor ? "pencil.circle.fill" : "pencil.circle")
            }
        }
    }
}

extension SceneState {

    // MARK: Transpose Buttons

    /// Transpose Up
    var transposeUp: some View {
        TransposeUp(sceneState: self)
    }
    /// Transpose Up
    private struct TransposeUp: View {
        /// The binding to the observable ``SceneState``
        @Bindable var sceneState: SceneState
        /// The body of the `View`
        var body: some View {
            Button {
                sceneState.song.metaData.transpose += 1
            } label: {
                Label("♯", systemImage: sceneState.song.metaData.transpose > 0 ? "arrow.up.circle.fill" : "arrow.up.circle")
            }
        }
    }

    /// Transpose Down
    var transposeDown: some View {
        TransposeDown(sceneState: self)
    }
    /// Transpose Down
    private struct TransposeDown: View {
        /// The binding to the observable ``SceneState``
        @Bindable var sceneState: SceneState
        /// The body of the `View`
        var body: some View {
            Button {
                sceneState.song.metaData.transpose -= 1
            } label: {
                Label("♭", systemImage: sceneState.song.metaData.transpose < 0 ? "arrow.down.circle.fill" : "arrow.down.circle")
            }
        }
    }
}

extension SceneState {

    // MARK: Transpose Menu

    /// Transpose Menu
    var transposeMenu: some View {
        TransposeMenu(sceneState: self)
    }
    /// Transpose Menu
    private struct TransposeMenu: View {
        /// The binding to the observable ``SceneState``
        @Bindable var sceneState: SceneState
        /// The body of the `View`
        var body: some View {
            ControlGroup {
                sceneState.transposeDown
                sceneState.transposeUp
            }
        }
    }
}

extension SceneState {

    // MARK: Audio Player Buttons

    /// Audio Player Buttons
    var audioPlayerButtons: some View {
        AudioPlayerButtons(sceneState: self)
    }
    /// Audio Player Buttons
    private struct AudioPlayerButtons: View {
        /// The binding to the observable ``SceneState``
        @Bindable var sceneState: SceneState
        /// The body of the `View`
        var body: some View {
            if let musicURL = getMusicURL() {
                AudioPlayerView(musicURL: musicURL)
                    .padding(.leading)
            } else {
                EmptyView()
            }
        }
        /// Get the URL for the music file
        /// - Returns: A full URL to the file, if found
        private func getMusicURL() -> URL? {
            guard let file = sceneState.file, let path = sceneState.song.metaData.musicPath else {
                return nil
            }
            var musicURL = file.deletingLastPathComponent()
            musicURL.appendPathComponent(path)
            return musicURL
        }
    }
}
