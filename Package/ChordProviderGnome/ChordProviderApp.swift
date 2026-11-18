//
//  ChordProviderApp.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Adwaita
import CAdw
import ChordProviderCore
import SourceEditor
import ChordProviderMIDI
import Foundation

/// The **Chord Provider** GNOME application
@main
struct ChordProviderApp: App {

    /// The application
    let app = AdwaitaApp(id: "nl.desbeers.chordprovider")
    /// The state of the application
    /// - Note: This will load all the settings
    @State("AppState")
    private var appState = AppState()
    /// The state of the database
    @State("DatabaseState")
    private var databaseState = DatabaseState()
    /// The list of recent songs
    @State("RecentSongs")
    private var recentSongs = RecentSongs()
    /// The size of the application window
    /// - Note: Will be used when opening a new instance of **ChordProvider**
    @State("WindowSize")
    private var windowSize = AppState.WindowSize(
        width: 800,
        height: 600
    )
    /// The size of the database window
    /// - Note: Will be used when opening a new instance of the database
    @State("DatabaseWindowSize")
    private var databaseWindowSize = AppState.WindowSize(
        width: 800,
        height: 600
    )
    /// The body of the `Scene`
    var scene: Scene {

        // MARK: Main Window

        Window(id: "main") { window in
            Views.Main(
                app: app,
                window: window,
                appState: $appState,
                recentSongs: $recentSongs
            )
            .css {
                appState.bridge.css(colorfull: appState.settings.editor.colorfullWindow)
            }
            .inspectOnAppear { storage in
                // Init the chords database
                appState.initDatabase()

                // Setup the `GtkSourceView`controller
                appState.controller.setup(
                    bridge: $appState.bridge,
                    scheme: $appState.settings.editor.scheme,
                    storage: storage,
                    onNew: {
                        print("NEW CALLBACK")
                        appState.scene.toastMessage = "Test"
                        appState.openMainView()
                    },
                    onOpen: { result in
                        switch result {
                        case .success(let fileURL):
                            if appState.settings.core.templateURL == nil {
                                appState.settings.core.fileURL = fileURL
                                recentSongs.addRecentSong(
                                    content: appState.controller.text,
                                    coreSettings: appState.settings.core
                                )
                                appState.scene.toastMessage = "Opened \(fileURL.deletingPathExtension().lastPathComponent)"
                                appState.scene.showToast.signal()
                            }
                            appState.openMainView()
                        case .failure(let error):
                            appState.settings.core.fileURL = nil
                            appState.scene.throwError(
                                error: ChordProviderError.fileNotOpened(
                                    error: error.localizedDescription
                                ),
                                main: true
                            )
                        }
                    },
                    onSave: { result in
                        switch result {
                        case .success(let fileURL):
                            appState.settings.core.templateURL = nil
                            appState.settings.core.fileURL = fileURL
                            recentSongs.addRecentSong(
                                content: appState.song.content,
                                coreSettings: appState.settings.core
                            )
                            appState.getFolderContent()
                        case .failure(let error):
                            if case SourceEditorError.noURL = error {
                                appState.scene.saveSongAs.signal()
                            } else {
                                appState.scene.throwError(
                                    error: ChordProviderError.fileNotSaved(
                                        error: error.localizedDescription
                                    ),
                                    main: true
                                )
                            }
                        }
                    },
                    onSchemeChanged: {
                        appState.setStyle()
                    }
                )
                // Attach the CSS provider to the default display
                if let display = gdk_display_get_default() {
                    gtk_style_context_add_provider_for_display(
                        display,
                        appState.cssProvider.opaque(),
                        guint(GTK_STYLE_PROVIDER_PRIORITY_APPLICATION)
                    )
                }
                // Init the MIDI player
                let referenceFrequency = appState.settings.core.referenceFrequency
                let preset = appState.settings.core.midiPreset
                Task { @concurrent in
                    await ChordProviderMIDI.shared.setReferenceFrequency(referenceFrequency)
                    await ChordProviderMIDI.shared.setProgram(preset: preset)
                }
                // Init the css style
                //appState.setStyle()
                // Get the songs from the library
                appState.getFolderContent()
            }
        }
        // - Note: It will remember the window size when opening a new window
        // .size(width: $windowSize.width, height: $windowSize.height)
        .defaultSize(width: 1024, height: 800)
        .minSize(width: 1024, height: 800)
        .maximized($windowSize.maximized)
        .fullscreen($appState.scene.fullscreen)
        // This is what you see in the GNOME overview
        .title(appState.overviewTitle)
        // Open a song when an URL is passed as argument
        .onOpen { urls in
            guard let url = urls.first else {
                // Just open the *home* window
                return
            }
            appState.scene.viewStatus = .openingSong
            app.showWindow("main")
            if appState.contentIsModified {
                // The current song is modified; show a dialog
                appState.scene.saveDoneAction = .openURL(url)
                appState.scene.showModifiedSongDialog = true
                return
            }
            // Open the song
            appState.settings.showEditor = false
            appState.openSong(fileURL: url)
        }
        .onClose {
            if appState.contentIsModified {
                appState.scene.saveDoneAction = .closeWindow
                appState.scene.showModifiedSongDialog = true
                return .cancel
            }
            return .close
        }

        // MARK: Database Window

        Window(id: "database", open: 0) { window in
            Views.Database(
                window: window,
                appState: $appState,
                databaseState: $databaseState
            )
        }
        /// - Note: It will remember the window size when opening a new window
        .size(width: $databaseWindowSize.width, height: $databaseWindowSize.height)
        .minSize(width: 1000, height: 600)
        .defaultSize(width: 1024, height: 600)
        .title("Chords Database")
        .maximized($databaseWindowSize.maximized)
        .onClose {
            if appState.currentInstrument.modified {
                /// The instrument is modified; show a *Dialog* to save it
                databaseState.saveDoneAction = .closeWindow
                databaseState.showChangedDatatabaseDialog = true
                return .cancel
            }
            return .close
        }
    }
}
