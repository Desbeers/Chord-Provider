//
//  AppState.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore
import SourceView
import Adwaita
import CAdw

/// The state of **Chord Provider**
struct AppState {
    /// The shared application settings
    var settings = AppSettings() {
        didSet {
            /// Update the style if needed
            if settings.theme != oldValue.theme {
                self.setStyle()
            }
            /// Update the core settings of the song if needed
            if settings.core != oldValue.core {
                self.editor.song.settings = settings.core
            }
        }
    }
    /// The state of the `Scene`
    /// - Note: Stuff that is only relevant for the current instance of **ChordProvider**
    var scene = Scene()
    /// The source view bridge
    var editor = SourceViewBridge(song: Song(id: UUID(), content: ""))
    /// The `GtkSourceEditor`class to communicate with `Swift`
    /// - Note: A lot of `C` stuff is easier with a `class`
    var controller: SourceViewController?
    /// The `Adwaita` style manager
    let styleManager = adw_style_manager_get_default()
    /// The CSS provider
    var cssProvider: UnsafeMutablePointer<GtkCssProvider> = gtk_css_provider_new()
    /// Modified Instrument
    /// - Note: That can only be one
    var modifiedInstrument: Instrument?
}

extension AppState {

    // MARK: Calculated stuff

    /// The title of the `Scene`
    var title: String {
        return self.editor.song.metadata.title
    }

    /// The subtitle of the `Scene`
    var subtitle: String {
        let metadata = self.editor.song.metadata
        var subtitle: [String] = [metadata.subtitle ?? metadata.artist]
            if let album = metadata.album {
                subtitle.append(album)
            }
            if contentIsModified {
            	    subtitle.append("modified")
            }
            return subtitle.joined(separator: " · ")
    }

    /// The title in the Gnome overview
    var overviewTitle: String {
        let appName = "Chord Provider"
        let fileName = settings.core.fileURL?.deletingPathExtension().lastPathComponent
        return scene.showWelcomeView ? appName : fileName ?? appName
    }

    /// Bool if the content of the song is modified
    /// - Note: Comparing the source with the original source
    var contentIsModified: Bool {
        editor.song.content != scene.originalContent
    }

    /// Chord instruments
    var chordInstruments: [Instrument] {
        var instruments = Instrument.buildIn
        instruments.append(contentsOf: self.settings.app.customInstruments)
        if let modifiedInstrument {
            instruments.append(modifiedInstrument)
        }
        return instruments
    }
}

extension AppState: Codable {
    
    /// Items to save in the database
    enum CodingKeys: String, CodingKey {
        /// Only save the settings
        case settings
    }
}

extension AppState {

    mutating func updateDatabase(instrument: Instrument) {
        let database = try? ChordsDatabase(instrument: instrument)
        self.settings.core.database = database ?? ChordsDatabase()
        self.editor.command = .updateSong
    }

    mutating func importDatabase(url: URL) {
        do {
            let database = try ChordsDatabase(url: url)
            self.settings.core.database = database
            self.editor.command = .updateSong
            /// Add this database to the custom list
            self.settings.app.customInstruments.append(database.instrument)
        } catch {
            self.scene.errorTitle = "Could not open the definitions"
            self.scene.errorMessage = "It looks like it is not a valid JSON file"
            self.scene.errorDetails = error.localizedDescription
            self.scene.showErrorDialog = true              
        }
    }
}