//
//  SceneState+Elements.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import QuickLook

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
            Menu {
                ControlGroup {
                    sceneState.transposeDown
                    sceneState.transposeUp
                }
                .controlGroupStyle(.palette)
                Text("Transposed by \(sceneState.song.metaData.transpose.description) semitones")
            } label: {
                Label(
                    "Transpose", systemImage: icon)
                    .imageScale(.small)
            }
        }
        /// The transpose button icon
        var icon: String {
            switch sceneState.song.metaData.transpose {
            case ...(-1):
                "arrow.down.circle.fill"
            case 1...:
                "arrow.up.circle.fill"
            default:
                "arrow.up.arrow.down.circle"
            }
        }
    }
}

extension SceneState {

    // MARK: Song ShareLink

    /// Song ShareLink
    var songShareLink: some View {
        SongShareLink(sceneState: self)
    }
    /// Song ShareLink
    private struct SongShareLink: View {
        /// The binding to the observable ``SceneState``
        @Bindable var sceneState: SceneState
        /// The body of the `View`
        var body: some View {
            ShareLink(item: sceneState.exportURL)
                .labelStyle(.iconOnly)
        }
    }
}

extension SceneState {

    // MARK: Quicklook Button

    /// Quicklook Button
    var quicklook: some View {
        Quicklook(sceneState: self)
    }
    /// Quicklook Button
    private struct Quicklook: View {
        /// The binding to the observable ``SceneState``
        @Bindable var sceneState: SceneState
        /// The body of the `View`
        var body: some View {
            Button(
                action: {
                    sceneState.quicklookURL = sceneState.quicklookURL == nil ? sceneState.exportURL : nil
                },
                label: {
                    Label("PDF preview", systemImage: sceneState.quicklookURL == nil ? "eye" : "eye.fill")
                }
            )
            /// QuickView does not always work when the editor is open, so just disable it if so...
            .disabled(sceneState.showEditor)
            .labelStyle(.iconOnly)
            .quickLookPreview($sceneState.quicklookURL)
        }
    }
}

extension SceneState {

    // MARK: Show Settings Toggle

    /// Show Settings Toggle
    var showSettingsToggle: some View {
        ShowSettingsToggle(sceneState: self)
    }
    /// Show Settings Toggle
    private struct ShowSettingsToggle: View {
        /// The binding to the observable ``SceneState``
        @Bindable var sceneState: SceneState
        /// The body of the `View`
        var body: some View {
            Button(
                action: {
                    sceneState.showSettings.toggle()
                },
                label: {
                    Label("Settings", systemImage: "gear")
                }
            )
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
