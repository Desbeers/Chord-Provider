//
//  ChordProvider.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore
import SourceView
import CAdw

/// The **Chord Provider** application
@main struct ChordProvider: App {
    /// Init the application
    init() {
        /// - Note: Give it an unique ID so Files does not open new windows
        let id: UUID = UUID()
        self.app = AdwaitaApp(id: "nl.desbeers.chordprovider._\(id.uuidString)")
        DatabaseInformation.setPath(
            AdwaitaApp.userDataDir().appendingPathComponent("nl.desbeers.chordprovider.sqlite").path
        )
    }
    /// The application
    let app: AdwaitaApp
    /// The state of the application
    /// - Note: This will load all the settings
    @State("AppState") private var appState = AppState()
    /// The state of the database
    @State("DatabaseState") private var databaseState = DatabaseState()
    /// The list of recent songs
    @State("RecentSongs") private var recentSongs = RecentSongs()
    /// The size of the application window
    /// - Note: Will be used when opening a new instance of **ChordProvider**
    @State("WindowSize") private var windowSize: AppState.WindowSize = .init(width: 800, height: 600)
    /// The size of the database window
    /// - Note: Will be used when opening a new instance of the database
    @State("DatabaseWindowSize") private var databaseWindowSize: AppState.WindowSize = .init(width: 800, height: 600)
    /// The body of the `Scene`
    var scene: Scene {

        // MARK: Main Window

        Window(id: "main") { window in
            Views.Content(
                app: app,
                window: window,
                appState: $appState,
                recentSongs: $recentSongs

            )
            .inspectOnAppear { storage in
                /// Init the chords database
                appState.initDatabase()
                /// Init the `GtkSourceView`controller
                appState.controller = SourceViewController(bridge: $appState.editor, language: .chordpro)
                /// Attach the CSS provider to the default display
                if let display = gdk_display_get_default() {
                    gtk_style_context_add_provider_for_display(
                        display,
                        appState.cssProvider.opaque(),
                        guint(GTK_STYLE_PROVIDER_PRIORITY_APPLICATION)
                    )
                }
                /// Init the MIDI player
                let referenceFrequency = appState.editor.coreSettings.referenceFrequency
                let preset = appState.editor.coreSettings.midiPreset
                Task {
                    await Utils.MidiPlayer.shared.setReferenceFrequency(referenceFrequency)
                    await Utils.MidiPlayer.shared.setPreset(preset)
                }
                /// Init the css style
                appState.setStyle()
                /// Add a *notification* for style changes
                storage.notify(name: "dark", pointer: appState.styleManager) {
                    appState.setStyle()
                }
                /// Open a song when passed as argument at launch
                /// - Note: When opened again with another argument; 
                ///         it will create a new instance because the application will have a another ID
                if let fileURL = CommandLine.arguments[safe: 1] {
                    let url = URL(filePath: fileURL)
                    /// - Note: Hide the editor because it is flashing if a song is directly opened
                    appState.settings.editor.showEditor = false
                    appState.openSong(fileURL: url)
                    /// Add it to the recent songs list
                    recentSongs.addRecentSong(
                        content: appState.scene.originalContent,
                        coreSettings: appState.editor.coreSettings
                    )
                }
            }
        }
        .devel(appState.settings.app.debug)
        /// - Note: It will remember the window size when opening a new window
        .size(width: $windowSize.width, height: $windowSize.height)
        .defaultSize(width: 1024, height: 800)
        .minSize(width: 1024, height: 800)
        .maximized($windowSize.maximized)
        /// This is what you see in the Gnome overview
        .title(appState.overviewTitle)
        .onClose {
            if appState.contentIsModified {
                appState.scene.saveDoneAction = .closeWindow
                appState.scene.showCloseDialog = true
                return .cancel
            } else {
                return .close
            }
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
        .minSize(width: 800, height: 600)
        .defaultSize(width: 1024, height: 600)
        .title("Chords Database")
        .maximized($databaseWindowSize.maximized)
        .devel(appState.settings.app.debug)
        .onClose {
            if appState.currentInstrument.modified {
               /// The instrument is modified; show a *Dialog* to save it
                databaseState.saveDoneAction = .closeWindow
                databaseState.showChangedDatatabaseDialog = true
                return .cancel                
            } else {
                return .close
            }
        }
    }
}
