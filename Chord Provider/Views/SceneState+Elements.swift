//
//  SceneState+Elements.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

extension SceneState {

    // MARK: Scale Slider

    var scaleSlider: some View {
        ScaleSlider(sceneState: self)
    }

    private struct ScaleSlider: View {
        @Bindable var sceneState: SceneState
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

    var showEditorButton: some View {
        ShowEditorButton(sceneState: self)
    }

    private struct ShowEditorButton: View {
        @Bindable var sceneState: SceneState
        var body: some View {
            Toggle(isOn: $sceneState.showEditor) {
                Label("Edit", systemImage: sceneState.showEditor ? "pencil.circle.fill" : "pencil.circle")
            }
        }
    }
}

extension SceneState {

    // MARK: Transpose Buttons

    var transposeUp: some View {
        TransposeUp(sceneState: self)
    }

    private struct TransposeUp: View {
        @Bindable var sceneState: SceneState
        var body: some View {
            Button {
                sceneState.song.transpose += 1
            } label: {
                Label("♯", systemImage: sceneState.song.transpose > 0 ? "arrow.up.circle.fill" : "arrow.up.circle")
            }
        }
    }

    var transposeDown: some View {
        TransposeDown(sceneState: self)
    }

    private struct TransposeDown: View {
        @Bindable var sceneState: SceneState
        var body: some View {
            Button {
                sceneState.song.transpose -= 1
            } label: {
                Label("♭", systemImage: sceneState.song.transpose < 0 ? "arrow.down.circle.fill" : "arrow.down.circle")
            }
        }
    }
}

extension SceneState {

    // MARK: Transpose Menu

    var transposeMenu: some View {
        TransposeMenu(sceneState: self)
    }

    private struct TransposeMenu: View {
        @Bindable var sceneState: SceneState
        var body: some View {
            Menu {
                ControlGroup {
                    sceneState.transposeDown
                    sceneState.transposeUp
                }
                .controlGroupStyle(.palette)
                Text("Transposed by \(sceneState.song.transpose.description) semitones")
            } label: {
                Label(
                    "Transpose", systemImage: icon)
                    .imageScale(.small)
            }
        }
        var icon: String {
            switch sceneState.song.transpose {
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

    var songShareLink: some View {
        SongShareLink(sceneState: self)
    }

    private struct SongShareLink: View {
        @Bindable var sceneState: SceneState
        var body: some View {
            ShareLink(item: sceneState.song.exportURL)
                .labelStyle(.iconOnly)
        }
    }
}

extension SceneState {

    // MARK: PDF inspector toggle

    var pdfInspector: some View {
        PDFInspector(sceneState: self)
    }

    private struct PDFInspector: View {
        @Bindable var sceneState: SceneState
        var body: some View {
            Toggle(isOn: $sceneState.showInspector) {
                Label("PDF preview", systemImage: sceneState.showInspector ? "eye.fill" : "eye")
            }
            .labelStyle(.iconOnly)
        }
    }
}

extension SceneState {

    // MARK: Show Settings Toggle

    var showSettingsToggle: some View {
        ShowSettingsToggle(sceneState: self)
    }

    private struct ShowSettingsToggle: View {
        @Bindable var sceneState: SceneState
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

    var audioPlayerButtons: some View {
        AudioPlayerButtons(sceneState: self)
    }

    private struct AudioPlayerButtons: View {
        @Bindable var sceneState: SceneState
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
            guard let file = sceneState.file, let path = sceneState.song.musicPath else {
                return nil
            }
            var musicURL = file.deletingLastPathComponent()
            musicURL.appendPathComponent(path)
            return musicURL
        }
    }
}
