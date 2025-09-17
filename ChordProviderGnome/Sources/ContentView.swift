//
//  File.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore
import ChordProviderHTML

struct ContentView: View {
    var app: AdwaitaApp
    var window: AdwaitaWindow
    @State private var settings = AppSettings()
    let id = UUID()

    var view: Body {

        SplitView(splitter: $settings.editor.splitter) {
            EditorView(settings: $settings)
        } end: {
            VStack {
                RenderView(render: settings.app.source, id: id, settings: settings)
                    .hexpand()
                    .vexpand()
                if settings.editor.showEditor {
                    LogView()
                        .transition(.coverUpDown)
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
            heading: "File has Changed",
            body: "Do you want to save your file?",
            id: "dirty-dialog"
        )
        .response("Cancel", role: .close) {
            // Nothing to do
        }
        .response("Discard", appearance: .destructive, role: .none) {
            switch settings.app.saveDoneAction {
            case .close:
                window.close()
            case .openSong:
                settings.app.openSong.signal()
            case .noAction:
                return
            }
        }
        .response("Save", appearance: .suggested, role: .default) {
            if let songURL = settings.core.songURL {
                try? settings.app.source.write(to: songURL, atomically: true, encoding: String.Encoding.utf8)
                switch settings.app.saveDoneAction {
                case .close:
                    window.close()
                case .openSong:
                    settings.app.openSong.signal()
                case .noAction:
                    /// Set the toast
                    settings.app.toastMessage = "Saved \(songURL.deletingPathExtension().lastPathComponent)"
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
        .toast(settings.app.toastMessage, signal: settings.app.showToast)
        .fileImporter(
            open: settings.app.openSong,
            extensions: ["chordpro", "cho"]
        ) { url in
            if let content = try? String(contentsOf: url, encoding: .utf8) {
                settings.core.songURL = url
                settings.app.source = content
                settings.app.originalSource = content
                /// Show the toast
                settings.app.toastMessage = "Opened \(url.deletingPathExtension().lastPathComponent)"
                settings.app.showToast.signal()
            }
        } onClose: {
            /// Nothing to do
        }
        .fileExporter(
            open: settings.app.saveSongAs,
            initialName: settings.core.initialName
        ) { url in
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
            try? string.write(to: url, atomically: true, encoding: String.Encoding.utf8)
            /// Remember the new source URL when saved as a **ChordPro** file
            if settings.core.export.format == .chordPro {
                settings.core.songURL = url
                /// The new state of the song
                settings.app.originalSource = settings.app.source
                /// Set the toast
                settings.app.toastMessage = "Saved as \(url.deletingPathExtension().lastPathComponent)"
            } else {
                /// Set the toast
                settings.app.toastMessage = "Exported as \(url.lastPathComponent)"
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
