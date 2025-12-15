//
//  Views+Content.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension Views {

    /// The main `View` for the application
    struct Content: View {
        /// The `AdwaitaApp`
        var app: AdwaitaApp
        /// The `AdwaitaWindow`
        var window: AdwaitaWindow
        /// The state of the application
        @Binding var appState: AppState
        /// The whole song
        @Binding var song: Song
        /// Bool if the song is parsing
        @State private var parsing: Bool = false

        // MARK: Main View

        /// The main `View`
        var view: Body {
            VStack {
                if appState.scene.showWelcome {
                    Views.Welcome(app: app, window: window, appState: $appState)
                        .vexpand()
                        .hexpand()
                        .transition(.crossfade)
                } else {
                    Views.Render(app: app, window: window, song: song, appState: $appState)
                        .hexpand()
                        .vexpand()
                        .transition(.crossfade)
                }
            }

            // MARK: On Update

            .onUpdate {
                if appState.scene.source != song.content || song.settings != appState.settings.core {
                    parse()
                }
            }

            // MARK: About Dialog

            /// The **About dialog**
            ///
            /// - Note: It would be nice if we could add some more stuff to this dialog
            /// - Credits
            /// - Troubleshooting
            .aboutDialog(
                visible: $appState.scene.showAboutDialog,
                app: "Chord Provider",
                developer: "Nick Berendsen",
                version: "dev",
                icon: .custom(name: "nl.desbeers.chordprovider"),
                // swiftlint:disable:next force_unwrapping
                website: URL(string: "https://github.com/Desbeers/Chord-Provider")!,
                // swiftlint:disable:next force_unwrapping
                issues: URL(string: "https://github.com/Desbeers/Chord-Provider/issues")!
            )

            // MARK: Transpose Song Dialog

            /// The dialog to ** Transpose Song**
            .dialog(
                visible: $appState.scene.showTransposeDialog,
                title: "Transpose the song",
                width: 260,
                height: 180
            ) {
                Views.Transpose(appState: $appState, song: song)
            }

            // MARK: Alert Dialog

            /// The **Alert dialog** when a song is changed but not yet saved
            .alertDialog(
                visible: $appState.scene.showDirtyClose,
                heading: "'\(song.metadata.title)' has changed",
                body: "Do you want to save your song?",
                id: "dirty-dialog"
            )
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
                    appState.saveSong(song)
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
                    /// The song has not yet been saved; show the *Save As* dialog
                    appState.settings.core.export.format = .chordPro
                    appState.scene.saveSongAs.signal()
                }
            }

            // MARK: Preference dialog

            /// The **Preference Dialog**
            ///
            /// - Note: It would be nice if the pages can be added in an overload
            .preferencesDialog(visible: $appState.scene.showPreferences)
            .preferencesPage("General", icon: .default(icon: .folderMusic)) { page in
                page
                    .group("Display your song") {
                        SwitchRow()
                            .title("Show only lyrics")
                            .subtitle("Hide all the chords")
                            .active($appState.settings.core.lyricsOnly)
                        SwitchRow()
                            .title("Repeat whole chorus")
                            .subtitle("Show the whole chorus with the same label")
                            .active($appState.settings.core.repeatWholeChorus)
                    }
                    .group("Chord Diagrams") {
                        SwitchRow()
                            .title("Show left-handed chords")
                            .subtitle("Flip the chord diagrams")
                            .active($appState.settings.core.diagram.mirror)
                        SwitchRow()
                            .title("Show notes")
                            .subtitle("Show the notes of a chord in the diagram")
                            .active($appState.settings.core.diagram.showNotes)
                    }
            }
            .preferencesPage("Editor", icon: .default(icon: .textEditor)) { page in
                page
                    .group("Options for the editor") {
                        SwitchRow()
                            .title("Line Numbers")
                            .subtitle("Show the line numbers in the editor")
                            .active($appState.settings.editor.showLineNumbers)
                        SwitchRow()
                            .title("Wrap Lines")
                            .subtitle("Wrap lines when they are too long")
                            .active($appState.settings.editor.wrapLines)
                        ComboRow("Font Size", selection: $appState.settings.editor.fontSize, values: AppSettings.Editor.Font.allCases)
                            .subtitle("Select the font size for the editor")
                    }
            }

            // MARK: Toast

            /// The **Toast** message
            .toast(appState.scene.toastMessage.escapeHTML(), signal: appState.scene.showToast)

            // MARK: File Importer

            /// The **File Importer**
            .fileImporter(
                open: appState.scene.openSong,
                extensions: ["chordpro", "cho"]
            ) { fileURL in
                appState.openSong(fileURL: fileURL)
                appState.scene.showToast.signal()
            }

            // MARK: File Exporter

            /// The **File Exporter**
            .fileExporter(
                open: appState.scene.saveSongAs,
                initialName: song.initialName(format: appState.settings.core.export.format)
            ) { fileURL in
                switch appState.settings.core.export.format {
                case .chordPro:
                    appState.settings.core.fileURL = fileURL
                    appState.saveSong(song)
                    /// Set the toast
                    appState.scene.toastMessage = "Saved as '\(fileURL.deletingPathExtension().lastPathComponent)'"
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

            // MARK: Shortcuts Dialog

            .shortcutsDialog(visible: $appState.scene.showKeyboardShortcuts)
            .shortcutsSection("Song") { section in
                section
                    .shortcutsItem("Open", accelerator: "o".ctrl())
                    .shortcutsItem("Save", accelerator: " s".ctrl())
                    .shortcutsItem("Save As", accelerator: " s".ctrl().shift())
            }
            .shortcutsSection("Zoom") { section in
                section
                    .shortcutsItem("Zoom In", accelerator: "plus".ctrl())
                    .shortcutsItem("Zoom Out", accelerator: " minus".ctrl())
                    .shortcutsItem("Reset Zoom", accelerator: " 0".ctrl())
            }
            .shortcutsSection("General") { section in
                section
                    .shortcutsItem("Show preferences", accelerator: "comma".ctrl())
                    .shortcutsItem("Show keyboard shortcuts", accelerator: "question".ctrl())
            }
            .shortcutsSection { $0.shortcutsItem("Quit Chord Provider", accelerator: "q".ctrl()) }
        }
        
        /// Parse the song
        func parse() {
            if !parsing {
                parsing = true
                Idle(priority: .low) {
                    LogUtils.shared.clearLog()
                    song.content = appState.scene.source
                    song.settings = appState.settings.core
                    song = ChordProParser.parse(
                        song: song,
                        settings: appState.settings.core
                    )
                    /// Update the recent song list
                    /// - Note: It will only do that when the song has an URL and is not dirty
                    appState.addRecentSong(song: song)
                    parsing = false
                }
            }
        }
    }
}
