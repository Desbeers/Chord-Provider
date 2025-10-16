//
//  ContentView.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore
import ChordProviderHTML

/// The main `View` for the application
struct ContentView: View {
    init(app: AdwaitaApp, window: AdwaitaWindow, appState: Binding<AppState>, id: UUID) {
        print("Content Init")
        LogUtils.shared.clearLog()
        self.app = app
        self.window = window
        self._appState = appState
        let song = Song(id: id, content: appState.scene.source.wrappedValue)
        
        let result = ChordProParser.parse(
            song: song,
            settings: appState.settings.core.wrappedValue
        )
        self.song = result
    }
    
    /// The `AdwaitaApp`
    var app: AdwaitaApp
    /// The `AdwaitaWindow`
    var window: AdwaitaWindow
    /// The ``AppState``
    @Binding var appState: AppState
    /// The song
    let song: Song
    /// The body of the `View`
    var view: Body {
        HSplitView(splitter: $appState.settings.editor.splitter) {
            EditorView(appState: $appState)
        } end: {
            VStack {
                if appState.scene.showWelcome {
                    WelcomeView(appState: $appState)
                        .vexpand()
                        .hexpand()
                        .transition(.coverLeftRight)
                } else {
                    RenderView(song: song, settings: appState.settings)
                        .hexpand()
                        .vexpand()
                        .transition(.coverRightLeft)
                    if appState.settings.editor.showEditor {
                        LogView()
                            .transition(.coverUpDown)
                    }
                }
            }
        }
        .vexpand()
        .hexpand()
        .topToolbar {
            ToolbarView(
                app: app,
                window: window,
                appState: $appState
            )
        }
        .aboutDialog(
            visible: $appState.scene.showAboutDialog,
            app: "Chord Provider",
            developer: "Nick Berendsen",
            version: "dev",
            icon: .custom(name: "nl.desbeers.chordprovider"),
            // swiftlint:disable:next force_unwrapping
            website: .init(string: "https://github.com/Desbeers/Chord-Provider")!,
            // swiftlint:disable:next force_unwrapping
            issues: .init(string: "https://github.com/Desbeers/Chord-Provider/issues")!
        )
        .dialog(
            visible: $appState.scene.showTransposeDialog,
            title: "Transpose the song",
            width: 260,
            height: 180)
        {
            TransposeView(appState: $appState)
        }
        .alertDialog(
            visible: $appState.scene.showDirtyClose,
            heading: "Song has changed",
            body: "Do you want to save your song?",
            id: "dirty-dialog"
        )
        .response("Cancel", role: .close) {
            // Nothing to do
        }
        .response("Discard", appearance: .destructive, role: .none) {
            switch appState.scene.saveDoneAction {
            case .close:
                /// Make the source 'clean'
                appState.scene.originalSource = appState.scene.source
                /// Close the window
                window.close()
            case .openSong:
                appState.scene.openSong.signal()
            case .noAction:
                return
            }
        }
        .response("Save", appearance: .suggested, role: .default) {
            if let fileURL = appState.settings.core.fileURL {
                try? appState.scene.source.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
                switch appState.scene.saveDoneAction {
                case .close:
                    window.close()
                case .openSong:
                    appState.scene.openSong.signal()
                case .noAction:
                    /// Set the toast
                    appState.scene.toastMessage = "Saved \(fileURL.deletingPathExtension().lastPathComponent)"
                    appState.scene.showToast.signal()
                }
            } else {
                appState.settings.core.export.format = .chordPro
                appState.scene.saveSongAs.signal()
            }
        }
        .dialog(visible: $appState.scene.showPreferences, title: "Preferences", width: 400, height: 410) {
            SettingsView(settings: $appState.settings)
                .topToolbar {
                    HeaderBar.empty()
                }
        }
        .toast(appState.scene.toastMessage.escapeHTML(), signal: appState.scene.showToast)
        .fileImporter(
            open: appState.scene.openSong,
            extensions: ["chordpro", "cho"]
        ) { fileURL in
            if let content = try? String(contentsOf: fileURL, encoding: .utf8) {
                appState.settings.core.fileURL = fileURL
                appState.scene.source = content
                appState.scene.originalSource = content
                /// Show the toast
                appState.scene.toastMessage = "Opened \(fileURL.deletingPathExtension().lastPathComponent)"
                appState.scene.showToast.signal()
                /// Append to recent
                appState.settings.app.addRecentSong(fileURL: fileURL)
                /// Hide the welcome
                appState.scene.showWelcome = false
            }
        } onClose: {
            /// Nothing to do
        }
        .fileExporter(
            open: appState.scene.saveSongAs,
            initialName: appState.settings.core.initialName
        ) { fileURL in
            var string = appState.scene.source
            /// If we want to export HTML, let's do it...
            if appState.settings.core.export.format == .html {
                var song = Song(id: UUID(), content: appState.scene.source)
                song = ChordProParser.parse(
                    song: song,
                    settings: appState.settings.core
                )
                string = HtmlRender.render(song: song, settings: appState.settings.core)
            }
            try? string.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
            /// Remember the new source URL when saved as a **ChordPro** file
            if appState.settings.core.export.format == .chordPro {
                appState.settings.core.fileURL = fileURL
                /// The new state of the song
                appState.scene.originalSource = appState.scene.source
                /// Set the toast
                appState.scene.toastMessage = "Saved as \(fileURL.deletingPathExtension().lastPathComponent)"
            } else {
                /// Set the toast
                appState.scene.toastMessage = "Exported as \(fileURL.lastPathComponent)"
            }
            switch appState.scene.saveDoneAction {
            case .close:
                window.close()
            case .openSong:
                appState.scene.openSong.signal()
            case .noAction:
                appState.scene.showToast.signal()
            }
        } onClose: {
            /// Nothing to do
        }
    }
}
