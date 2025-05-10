//
//  MainView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import OSLog

/// SwiftUI `View` for the main content
struct MainView: View {
    /// The observable state of the application
    @Environment(AppStateModel.self) private var appState
    /// The state of the scene
    @State private var sceneState = SceneStateModel()
    /// The observable ``FileBrowser`` class
    @Environment(FileBrowserModel.self) private var fileBrowser
    /// The ChordPro document
    @Binding var document: ChordProDocument
    /// The optional file URL of the song
    let fileURL: URL?
    /// The body of the `View`
    var body: some View {
        VStack(spacing: 0) {
            switch sceneState.status {
            case .loading:
                progress
            case .ready:
                if sceneState.preview.data == nil {
                    HeaderView()
                }
                main
            case .error:
                ContentUnavailableView(
                    "Ooops",
                    systemImage: "exclamationmark.triangle",
                    description: Text("Something went wrong")
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbar(id: "Main") {
            ToolbarView()
        }
        .errorAlert(message: $sceneState.errorAlert)
        .task {
            sceneState.song.metadata.fileURL = fileURL
            sceneState.template = document.template
            await renderSong()
            /// Always open the editor for a new file or a template
            if document.text == ChordProDocument.getSongTemplateContent() || document.template != nil {
                sceneState.showEditor = true
            }
            sceneState.status = .ready
        }
        .onChange(of: document.text) {
            Task {
                await renderSong()
            }
        }
        .onChange(of: sceneState.song.metadata.transpose) {
            Task {
                await renderSong()
            }
        }
        .onChange(of: appState.settings.shared) {
            sceneState.song.settings.shared = appState.settings.shared
            Task {
                await renderSong()
            }
        }
        .onChange(of: appState.settings.chordPro) {
            sceneState.song.settings.chordPro = appState.settings.chordPro
            Task {
                await renderSong()
            }
        }
        .onChange(of: appState.settings.pdf) {
            sceneState.song.settings.pdf = appState.settings.pdf
            Task {
                await renderSong()
            }
        }
        .onChange(of: appState.settings.style) {
            /// Reset chord cache; the theme might have changed
            RenderView.diagramCache.removeAllObjects()
            sceneState.song.settings.style = appState.settings.style
            Task {
                await renderSong()
            }
        }
        .onChange(of: appState.settings.diagram) {
            /// Reset chord cache; the theme might have changed
            RenderView.diagramCache.removeAllObjects()
            sceneState.song.settings.diagram = appState.settings.diagram
            Task {
                await renderSong()
            }
        }
        .onChange(of: sceneState.song.settings.display) {
            /// Store is in `appState` so it will be the defaults for the next song
            appState.settings.display = sceneState.song.settings.display
            Task {
                await renderSong()
            }
        }
        .onChange(of: appState.settings) {
            if sceneState.preview.data != nil {
                sceneState.preview.outdated = true
            }
        }
        .animation(.default, value: sceneState.preview)
        .animation(.default, value: sceneState.song.metadata)
        .animation(.default, value: sceneState.song.settings)
        .animation(.default, value: sceneState.status)
        /// Give the menubar access to the Scene State
        .focusedSceneValue(\.sceneState, sceneState)
        .environment(sceneState)
    }
    /// The main of the `View`
    var main: some View {
        HStack(spacing: 0) {
            if sceneState.showEditor {
                EditorView(document: $document)
                    .frame(minWidth: 300)
                    .frame(width: (sceneState.windowWidth / 2) + sceneState.editorOffset)
                    .transition(.opacity)
                SplitterView()
                    .transition(.scale)
            }
            if let data = sceneState.preview.data {
                PreviewPaneView(data: data)
                    .transition(.move(edge: .trailing))
            } else if sceneState.isAnimating {
                progress
            } else {
                let layout = sceneState.song.settings.display.chordsPosition == .right ?
                AnyLayout(HStackLayout(spacing: 0)) : AnyLayout(VStackLayout(spacing: 0))
                layout {
                    Group {
                        SongView()
                            .foregroundStyle(
                                appState.settings.style.fonts.text.color,
                                appState.settings.style.theme.foregroundMedium
                            )
                        if sceneState.song.settings.display.showChords {
                            Divider()
                            ChordsView(document: $document)
                                .background(Color(appState.settings.style.theme.background))
                                .shadow(color: .secondary.opacity(0.25), radius: 60)
                        }
                    }
                    .background(Color(appState.settings.style.theme.background))
                    /// - Note: Make sure we don't see the splitter cursor here
                    .pointerStyle(.default)
                }
            }
        }
        .frame(maxHeight: .infinity)
        /// Remember the size of the whole window
        .onGeometryChange(for: CGSize.self) { proxy in
            proxy.size
        } action: { newValue in
            sceneState.windowWidth = newValue.width
        }
    }

    /// Progress of the `View`
    var progress: some View {
        /// - Note: A ProgressView spinner cannot be styled on macOS
        Image(systemName: "music.quarternote.3")
            .symbolEffect(.bounce, options: .repeat(.continuous))
            .font(.largeTitle)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundStyle(appState.settings.style.theme.foregroundMedium)
            .background(Color(appState.settings.style.theme.background))
    }
    /// Render the song
    private func renderSong() async {
        sceneState.song.content = document.text
        sceneState.song.metadata.fileURL = fileURL
        sceneState.song = await ChordProParser.parse(song: sceneState.song)
        sceneState.getMedia()
        appState.lastUpdate = .now

        /// Pass the parsed song to the appState
        appState.song = sceneState.song
        if let index = fileBrowser.songs.firstIndex(where: { $0.metadata.fileURL == fileURL }) {
            fileBrowser.songs[index].metadata.title = sceneState.song.metadata.title
            fileBrowser.songs[index].metadata.artist = sceneState.song.metadata.artist
            fileBrowser.songs[index].metadata.tags = sceneState.song.metadata.tags
        }
    }
}
