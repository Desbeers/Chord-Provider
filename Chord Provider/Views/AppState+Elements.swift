//
//  AppState+Elements.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 29/02/2024.
//

import SwiftUI

extension AppState {

    // MARK: Chords Menu

    var chordsMenu: some View {
        ChordsMenu(appState: self)
    }

    private struct ChordsMenu: View {
        @Bindable var appState: AppState
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

    var showChordsButton: some View {
        ShowChordsButton(appState: self)
    }

    private struct ShowChordsButton: View {
        @Bindable var appState: AppState
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

    var chordsPositionPicker: some View {
        ChordsPositionPicker(appState: self)
    }

    private struct ChordsPositionPicker: View {
        @Bindable var appState: AppState
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

    var chordsAsDiagramToggle: some View {
        ChordsAsDiagramToggle(appState: self)
    }

    /// SwiftUI `View` with a togle to view inline diagrams
    private struct ChordsAsDiagramToggle: View {
        /// The app state
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

    var songPagingPicker: some View {
        SongPagingPicker(appState: self)
    }

    private struct SongPagingPicker: View {
        /// The app state
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
