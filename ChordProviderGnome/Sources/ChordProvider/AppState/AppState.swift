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
            if let year = metadata.year {
                subtitle.append(year)
            }
            if contentIsModified {
            	subtitle.append("modified")
            }
            return subtitle.joined(separator: " · ")
    }

    /// Bool if the content of the song is modified
    /// - Note: Comparing the source with the original source
    var contentIsModified: Bool {
        editor.song.content != scene.originalContent
    }
}

extension AppState: Codable {
    
    /// Items to save in the database
    enum CodingKeys: String, CodingKey {
        /// Only save the settings
        case settings
    }
}
