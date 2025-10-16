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
    /// The `AdwaitaApp`
    var app: AdwaitaApp
    /// The `AdwaitaWindow`
    var window: AdwaitaWindow
    /// The ``AppSettings``
    @Binding var settings: AppSettings
    /// The unique id
    let id = UUID()
    /// The body of the `View`
    var view: Body {
        HSplitView(splitter: $settings.editor.splitter) {
            EditorView(settings: $settings)
        } end: {
            VStack {
                if settings.app.showWelcome {
                    WelcomeView(settings: $settings)
                        .vexpand()
                        .hexpand()
                        .transition(.coverLeftRight)
                } else {
                    RenderView(render: settings.app.source, id: id, settings: settings)
                        .hexpand()
                        .vexpand()
                        .transition(.coverRightLeft)
                    if settings.editor.showEditor {
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
                settings: $settings
            )
        }
        .dialog(visible: $settings.app.transposeDialog, title: "Transpose the song", width: 260, height: 180) {
            TransposeView(settings: $settings)
        }
        .alertDialog(
            visible: $settings.app.showDirtyClose,
            heading: "Song has changed",
            body: "Do you want to save your song?",
            id: "dirty-dialog"
        )
        .response("Cancel", role: .close) {
            // Nothing to do
        }
        .response("Discard", appearance: .destructive, role: .none) {
            switch settings.app.saveDoneAction {
            case .close:
                /// Make the source 'clean'
                settings.app.originalSource = settings.app.source
                /// Close the window
                window.close()
            case .openSong:
                settings.app.openSong.signal()
            case .noAction:
                return
            }
        }
        .response("Save", appearance: .suggested, role: .default) {
            if let fileURL = settings.core.fileURL {
                try? settings.app.source.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
                switch settings.app.saveDoneAction {
                case .close:
                    window.close()
                case .openSong:
                    settings.app.openSong.signal()
                case .noAction:
                    /// Set the toast
                    settings.app.toastMessage = "Saved \(fileURL.deletingPathExtension().lastPathComponent)"
                    settings.app.showToast.signal()
                }
            } else {
                settings.core.export.format = .chordPro
                settings.app.saveSongAs.signal()
            }
        }
        .dialog(visible: $settings.app.showPreferences, title: "Preferences", width: 400, height: 410) {
            SettingsView(settings: $settings)
                .topToolbar {
                    HeaderBar.empty()
                }
        }
        .toast(settings.app.toastMessage.escapeHTML(), signal: settings.app.showToast)
        .fileImporter(
            open: settings.app.openSong,
            extensions: ["chordpro", "cho"]
        ) { fileURL in
            if let content = try? String(contentsOf: fileURL, encoding: .utf8) {
                settings.core.fileURL = fileURL
                settings.app.source = content
                settings.app.originalSource = content
                /// Show the toast
                settings.app.toastMessage = "Opened \(fileURL.deletingPathExtension().lastPathComponent)"
                settings.app.showToast.signal()
                /// Append to recent
                settings.app.addRecentSong(fileURL: fileURL)
                /// Hide the welcome
                settings.app.showWelcome = false
            }
        } onClose: {
            /// Nothing to do
        }
        .fileExporter(
            open: settings.app.saveSongAs,
            initialName: settings.core.initialName
        ) { fileURL in
            var string = settings.app.source
            /// If we want to export HTML, let's do it...
            if settings.core.export.format == .html {
                var song = Song(id: id, content: settings.app.source)
                song = ChordProParser.parse(
                    song: song,
                    settings: settings.core
                )
                string = HtmlRender.render(song: song, settings: settings.core)
            }
            try? string.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
            /// Remember the new source URL when saved as a **ChordPro** file
            if settings.core.export.format == .chordPro {
                settings.core.fileURL = fileURL
                /// The new state of the song
                settings.app.originalSource = settings.app.source
                /// Set the toast
                settings.app.toastMessage = "Saved as \(fileURL.deletingPathExtension().lastPathComponent)"
            } else {
                /// Set the toast
                settings.app.toastMessage = "Exported as \(fileURL.lastPathComponent)"
            }
            switch settings.app.saveDoneAction {
            case .close:
                window.close()
            case .openSong:
                settings.app.openSong.signal()
            case .noAction:
                settings.app.showToast.signal()
            }
        } onClose: {
            /// Nothing to do
        }
    }
}
