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
    /// Bool if the window is active
    @Environment(\.appearsActive) var appearsActive
    /// The optional file URL of the song
    let fileURL: URL?
    /// The body of the `View`
    var body: some View {
        ZStack {
            Rectangle()
                .fill(
                    appState.settings.style.theme.background
                )
            VStack(spacing: 0) {
                switch sceneState.status {
                case .loading:
                    progress
                case .ready:
                    if sceneState.songRenderer != .pdf {
                        HeaderView()
                            .transition(.move(edge: .top))
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

            // MARK: Calculate song item sizes

            /// Get the size of the longest song line
            /// - Note: This is not perfect but seems well enough for normal songs
            RenderView.PartsView(
                parts: sceneState.song.metadata.longestLine.parts ?? [],
                settings: sceneState.song.settings
            )
            /// Set the standard scaled font
            .font(sceneState.song.settings.style.fonts.text.swiftUIFont(scale: sceneState.song.settings.scale.magnifier))
            .onGeometryChange(for: CGSize.self) { proxy in
                proxy.size
            } action: { newValue in
                sceneState.song.settings.scale.maxSongLineWidth = newValue.width > 340 ? newValue.width : 340
            }
            .hidden()
            /// Get the size of the longest label line
            /// - Note: This is not perfect but seems well enough for normal songs
            RenderView.ProminentLabel(
                label: sceneState.song.metadata.longestLabel,
                font: sceneState.song.settings.style.fonts.label.swiftUIFont(scale: sceneState.song.settings.scale.magnifier),
                settings: sceneState.song.settings
            )
            .onGeometryChange(for: CGSize.self) { proxy in
                proxy.size
            } action: { newValue in
                sceneState.song.settings.scale.maxSongLabelWidth = newValue.width > 100 ? newValue.width : 100
            }
            .hidden()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbar(id: "Main") {
            ToolbarView()
        }
        .errorAlert(message: $sceneState.errorAlert)
        .task {
            sceneState.song.metadata.fileURL = fileURL
            sceneState.song.metadata.templateURL = document.templateURL
            await renderSong()
            /// Always open the editor for a new file or a template
            if document.text == ChordProDocument.getSongTemplateContent() || document.templateURL != nil {
                sceneState.showEditor = true
            }
            sceneState.status = .ready
        }
        .onChange(of: document.text) {
            Task {
                await renderSong(updatePreview: false)
            }
        }
        .onChange(of: sceneState.song.metadata.transpose) {
            Task {
                await renderSong()
            }
        }
        .onChange(of: appState.settings.application) {
            sceneState.song.settings.application = appState.settings.application
            Task {
                await renderSong()
            }
        }
        .onChange(of: appState.settings.chordProCLI) {
            sceneState.song.settings.chordProCLI = appState.settings.chordProCLI
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
        .onChange(of: appearsActive) { _, newValue in
            if newValue {
                /// Pass the song to the application state for the debug view because it has the focus
                appState.song = sceneState.song
            }
        }
        .animation(.easeInOut, value: sceneState.songRenderer)
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
                    .frame(width: sceneState.editorWidth)
                    .transition(.move(edge: .leading))
            }
            switch sceneState.songRenderer {
            case .standard:
                let layout = sceneState.song.settings.display.chordsPosition == .right ?
                AnyLayout(HStackLayout(spacing: 0)) : AnyLayout(VStackLayout(spacing: 0))
                layout {
                    Group {
                        SongView(song: sceneState.song)
                        /// Remember the size of the song part
                            .onGeometryChange(for: CGSize.self) { proxy in
                                proxy.size
                            } action: { newValue in
                                sceneState.song.settings.scale.maxSongWidth = newValue.width
                            }
                        if sceneState.song.settings.display.showChords {
                            Divider()
                            ChordsView(document: $document)
                                .background(appState.settings.style.theme.background)
                                .shadow(color: appState.settings.style.theme.foreground.opacity(0.2), radius: 50)
                        }
                    }
                    /// - Note: Make sure we don't see the splitter cursor here
                    .pointerStyle(.default)
                }
            case .pdf:
                PreviewPaneView()
                    .transition(.move(edge: .trailing))
            case .animating:
                progress
            }
        }
        .frame(maxHeight: .infinity)
        /// Remember the size of the whole window
        .onGeometryChange(for: CGSize.self) { proxy in
            proxy.size
        } action: { newValue in
            sceneState.windowWidth = newValue.width
        }
        .onDisappear {
            /// Remove this song from the Debug View if active
            if sceneState.song.id == appState.song?.id {
                appState.song = nil
                appState.lastUpdate = .now
            }
        }
    }

    /// Progress of the `View`
    var progress: some View {
        /// - Note: A ProgressView spinner cannot be styled on macOS
        Image(systemName: "music.quarternote.3")
            .symbolEffect(.bounce, options: .repeat(.continuous))
            .font(.largeTitle)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundStyle(
                appState.settings.style.theme.foregroundMedium
            )
    }
    /// Render the song
    private func renderSong(updatePreview: Bool = true) async {
        sceneState.song.content = document.text
        sceneState.song.metadata.fileURL = fileURL
        sceneState.song = await ChordProParser.parse(song: sceneState.song)
        sceneState.getMedia()
        appState.lastUpdate = .now

        /// Optional update the PDF preview
        if updatePreview, sceneState.songRenderer == .pdf {
            /// Render a new PDF
            if let pdf = try? await sceneState.exportSongToPDF() {
                /// Show the updated preview
                sceneState.preview.data = pdf
            }
        }

        /// Save the song to disk for sharing
        try? sceneState.song.content.write(to: sceneState.song.metadata.sourceURL, atomically: true, encoding: String.Encoding.utf8)

        /// Pass the parsed song to the appState
        appState.song = sceneState.song
        if let index = fileBrowser.songs.firstIndex(where: { $0.metadata.fileURL == fileURL }) {
            fileBrowser.songs[index].metadata.title = sceneState.song.metadata.title
            fileBrowser.songs[index].metadata.artist = sceneState.song.metadata.artist
            fileBrowser.songs[index].metadata.tags = sceneState.song.metadata.tags
        }
    }
}
