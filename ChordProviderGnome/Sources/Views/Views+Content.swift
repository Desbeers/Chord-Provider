//
//  Views+Content.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore
import ChordProviderHTML

extension Views {

    /// The main `View` for the application
    struct Content: View {
        /// Init the `View`
        init(app: AdwaitaApp, window: AdwaitaWindow, appState: Binding<AppState>, id: UUID) {
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
        /// The state of the application
        @Binding var appState: AppState
        /// The whole song
        let song: Song
        /// The body of the `View`
        var view: Body {
            HSplitView(splitter: $appState.settings.editor.splitter) {
                Views.Editor(appState: $appState)
            } end: {
                VStack {
                    if appState.scene.showWelcome {
                        Views.Welcome(appState: $appState)
                            .vexpand()
                            .hexpand()
                            .transition(.coverLeftRight)
                    } else {
                        Views.Render(song: song, settings: appState.settings)
                            .hexpand()
                            .vexpand()
                            .transition(.coverRightLeft)
                        if appState.settings.editor.showEditor {
                            Views.Log()
                                .transition(.coverUpDown)
                        }
                    }
                }
            }
            .vexpand()
            .hexpand()
            .topToolbar {
                Views.Toolbar(
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
                Views.Transpose(appState: $appState)
            }
            .alertDialog(
                visible: $appState.scene.showDirtyClose,
                heading: "'\(song.metadata.title)' has changed",
                body: "Do you want to save your song?",
                id: "dirty-dialog"
            )
            .response("Cancel", role: .close) {
                // Nothing to do
            }
            .response("Discard", appearance: .destructive, role: .none) {
                switch appState.scene.saveDoneAction {
                case .closeWindow:
                    /// Make the source 'clean' so we can close the window
                    appState.scene.originalSource = appState.scene.source
                    /// Close the window
                    window.close()
                case .showWelcomeScreen:
                    appState.showWelcomeScreen()
                case .noAction:
                    return
                }
            }
            .response("Save", appearance: .suggested, role: .default) {
                if let fileURL = appState.settings.core.fileURL {
                    try? appState.scene.source.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
                    /// Add it to the recent songs list
                    appState.settings.app.addRecentSong(fileURL: fileURL)
                    switch appState.scene.saveDoneAction {
                    case .closeWindow:
                        window.close()
                    case .showWelcomeScreen:
                        appState.showWelcomeScreen()
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
                Views.Settings(settings: $appState.settings)
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
            }
            .fileExporter(
                open: appState.scene.saveSongAs,
                initialName: song.initialName(format: appState.settings.core.export.format)
            ) { fileURL in
                switch appState.settings.core.export.format {
                case .chordPro:
                    appState.settings.core.fileURL = fileURL
                    appState.saveSong()
                    /// Set the toast
                    appState.scene.toastMessage = "Saved as '\(fileURL.deletingPathExtension().lastPathComponent)'"
                case .html:
                    appState.exportSong(song: song, exportURL: fileURL)
                    appState.scene.toastMessage = "Song exported as \(fileURL.lastPathComponent)"
                default:
                    break
                }
                switch appState.scene.saveDoneAction {
                case .closeWindow:
                    window.close()
                case .showWelcomeScreen:
                    appState.scene.showToast.signal()
                    appState.showWelcomeScreen()
                case .noAction:
                    appState.scene.showToast.signal()
                }
            }
        }
    }
}
