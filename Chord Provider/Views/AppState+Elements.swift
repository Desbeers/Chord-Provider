//
//  AppState+Elements.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

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
