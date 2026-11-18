//
//  AppState.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation
import ChordProviderCore
import SourceEditor
import Adwaita
import CAdw

/// The state of **Chord Provider**
@MainActor
struct AppState {

    /// The application settings
    var settings = AppSettings() {
        didSet {
            /// Update the style if needed
            if settings.theme != oldValue.theme {
                self.setStyle()
            }
        }
    }
    /// The state of the `Scene`
    /// - Note: Stuff that is only relevant for the current instance of **ChordProvider**
    var scene = Scene()
    /// The settings for the Home `View`
    var home = Home()
    /// The songs library
    var library = Library()
    /// The source view bridge
    var editor = Editor.Bridge()
    /// The `GtkSourceEditor` class to communicate with `Swift`
    /// - Note: A lot of `C` stuff is easier with a `class`
    var controller = Editor.Controller(resources: AppState.resourcesDirectory)
    /// The `Adwaita` style manager
    let styleManager = adw_style_manager_get_default()
    /// The CSS provider
    var cssProvider: UnsafeMutablePointer<GtkCssProvider> = gtk_css_provider_new()
    /// The current song
    var song = Song(id: UUID())
    /// The current cursor line
    var currentLine = Song.Section.Line()
}

extension AppState {

    // MARK: Calculated stuff

    /// The title of the `Scene`
    var title: String {
        song.hasContent ? song.metadata.title : "Chord Provider"
        // switch scene.viewStatus {
        // case .showHomeView:
        //
        // }
        // self.song.metadata.title
    }

    /// The subtitle of the `Scene`
    var subtitle: String {

        switch scene.viewStatus {
        case .openingSong:
            return "Opening Song"
        default:
            if song.hasContent {
                let metadata = self.song.metadata
                var result: [String] = [metadata.subtitle ?? metadata.artist]
                    if let album = metadata.album {
                        result.append(album)
                    }
                    if contentIsModified {
                        result.append("modified")
                    }
                    return result.joined(separator: " · ")
            } else {
                return "Empty song"
            }
        }
    }

    /// The resources directory of the bundle.
    static var resourcesDirectory: URL? {
        if let url = Bundle.module.url(forResource: "chordpro", withExtension: "snippets") {
            return url.deletingLastPathComponent()
        }
        return nil
    }

    /// The title in the GNOME overview
    var overviewTitle: String {
        let appName = "Chord Provider"
        let fileName = settings.core.fileURL?.deletingPathExtension().lastPathComponent
        return scene.viewStatus == .showHomeView ? appName : fileName ?? appName
    }

    /// Bool if the content of the song is modified
    /// - Note: Comparing the source with the original source
    var contentIsModified: Bool {
        editor.modified
    }
}

extension AppState: @MainActor Codable {

    /// Items to save in the database
    enum CodingKeys: String, CodingKey {
        /// Only save the settings
        case settings
        /// Home settings
        case home
    }
}

extension AppState {

    /// Update the song.
    /// - Parameter content: The content of the song.
    /// - Returns: Optional marks for the editor.
    mutating func updateSong(content: String) -> [SourceMark] {
        LogUtils.shared.clearLog()
        song = ChordProParser.parse(
            content: content,
            song: song,
            settings: settings.core
        )
        var markers: [SourceMark] = []
        if settings.core.showWarnings {
            /// Get all lines, removing anything added by the parser
            let lines = song.allLines.filter { $0.sourceLineNumber > 0 }
            for line in lines.filter({ line in !line.warnings.isEmpty }) {
                let level = line.warnings.compactMap(\.level).min() ?? .info
                markers.append(
                    SourceMark(
                        lineNumber: line.sourceLineNumber,
                        category: SourceMark.Category(rawValue: level.rawValue) ?? .info
                    )
                )
            }
        }
        scene.viewStatus = .showMainView
        return markers
    }
}

extension AppState {

    /// Set the current song line of the editor
    mutating func setCurrentLine() {
        let lines = song.allLines.filter { $0.sourceLineNumber > 0 }
        currentLine = lines[safe: editor.currentLineNumber - 1] ?? Song.Section.Line(sourceLineNumber: editor.lineCount)
    }
}
