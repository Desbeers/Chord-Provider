//
//  AppState+Elements.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

extension AppState {

    // MARK: Chords Menu

    /// Chords menu
    var chordsMenu: some View {
        ChordsMenu(appState: self)
    }
    /// Chords menu
    private struct ChordsMenu: View {
        /// The binding to the observable ``AppState``
        @Bindable var appState: AppState
        /// The body of the `View`
        var body: some View {
            Menu("Chords", systemImage: appState.settings.showChords ? "number.circle.fill" : "number.circle") {
                appState.showChordsButton
                Divider()
                appState.chordsPositionPicker
                    .pickerStyle(.inline)
            }
        }
    }
}

extension AppState {

    // MARK: Show Chords Button

    /// Show chords button
    var showChordsButton: some View {
        ShowChordsButton(appState: self)
    }
    /// Show chords button
    private struct ShowChordsButton: View {
        /// The binding to the observable ``AppState``
        @Bindable var appState: AppState
        /// The body of the `View`
        var body: some View {
            Button {
                appState.settings.showChords.toggle()
            } label: {
                Text(appState.settings.showChords ? "Hide Chords" : "Show Chords")
            }
        }
    }
}

extension AppState {

    // MARK: Chords Position Picker

    /// Chords Position Picker
    var chordsPositionPicker: some View {
        ChordsPositionPicker(appState: self)
    }
    /// Chords Position Picker
    private struct ChordsPositionPicker: View {
        /// The binding to the observable ``AppState``
        @Bindable var appState: AppState
        /// The body of the `View`
        var body: some View {
            Picker("Position:", selection: $appState.settings.chordsPosition) {
                ForEach(ChordProviderSettings.Position.allCases, id: \.rawValue) { value in
                    Text(value.rawValue)
                        .tag(value)
                }
            }
            .disabled(appState.settings.showChords == false)
        }
    }
}

extension AppState {

    // MARK: Chords As Diagram Toggle

    /// Chords As Diagram Toggle
    var chordsAsDiagramToggle: some View {
        ChordsAsDiagramToggle(appState: self)
    }

    /// Chords As Diagram Toggle
    private struct ChordsAsDiagramToggle: View {
        /// The binding to the observable ``AppState``
        @Bindable var appState: AppState
        /// The body of the `View`
        var body: some View {
            Toggle(isOn: $appState.settings.showInlineDiagrams) {
                Text("Chords as Diagram")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .toggleStyle(.switch)
            .minimumScaleFactor(0.1)
        }
    }
}

extension AppState {

    // MARK: Song Paging Picker

    /// Song Paging Picker
    var songPagingPicker: some View {
        SongPagingPicker(appState: self)
    }
    /// Song Paging Picker
    private struct SongPagingPicker: View {
        /// The binding to the observable ``AppState``
        @Bindable var appState: AppState
        /// The body of the `View`
        var body: some View {
            Picker("Pager:", selection: $appState.settings.paging) {
                ForEach(Song.DisplayOptions.Paging.allCases, id: \.rawValue) { value in
                    value.label
                        .tag(value)
                }
            }
        }
    }
}
