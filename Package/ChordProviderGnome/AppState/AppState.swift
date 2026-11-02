//
//  AppState.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation
import ChordProviderCore
import ChordProviderEditor
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
    var editor = SourceViewBridge()
    /// The `GtkSourceEditor` class to communicate with `Swift`
    /// - Note: A lot of `C` stuff is easier with a `class`
    var controller = SourceViewController()
    /// The `Adwaita` style manager
    let styleManager = adw_style_manager_get_default()
    /// The CSS provider
    var cssProvider: UnsafeMutablePointer<GtkCssProvider> = gtk_css_provider_new()
    /// The accent colors for Pango markup
    var pangoAccentColor: (red: UInt16, green: UInt16, blue: UInt16) = (red: 0, green: 0, blue: 0)


    var song = Song(id: UUID())

    /// The current cursor line
    public var currentLine = Song.Section.Line()

    /// Bool to show the *Edit directive* dialog
    public var showEditDirectiveDialog: Bool = false

    /// The directive to handle in the *Edit directive* dialog
    public var handleDirective: ChordPro.Directive?

}

extension AppState {

    // MARK: Calculated stuff

    /// The title of the `Scene`
    var title: String {
        self.song.metadata.title
    }

    /// The subtitle of the `Scene`
    var subtitle: String {
        let metadata = self.song.metadata
        var result: [String] = [metadata.subtitle ?? metadata.artist]
            if let album = metadata.album {
                result.append(album)
            }
            if contentIsModified {
                result.append("modified")
            }
            return result.joined(separator: " · ")
    }

    /// The title in the GNOME overview
    var overviewTitle: String {
        let appName = "Chord Provider"
        let fileName = settings.core.fileURL?.deletingPathExtension().lastPathComponent
        return scene.showHomeView ? appName : fileName ?? appName
    }

    /// Bool if the content of the song is modified
    /// - Note: Comparing the source with the original source
    var contentIsModified: Bool {
        song.content != scene.originalContent
    }
}

extension AppState: @MainActor Codable {

    /// Items to save in the database
    enum CodingKeys: String, CodingKey {
        /// Only save the settings
        case settings
        /// Core settings are in the editor
        //case editor
        /// Home settings
        case home
    }
}

extension AppState {

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
            //values.songLines = lines
            for line in lines.filter({ line in !line.warnings.isEmpty }) {
                let level = line.warnings.compactMap(\.level).min() ?? .info
                markers.append(
                    SourceMark(
                        lineNumber: line.sourceLineNumber,
                        category: SourceMark.Level(rawValue: level.rawValue) ?? .info
                    )
                )
            }
        }
        return markers
    }
}

extension AppState {

    mutating func setCurrentLine() {
        let lines = song.allLines.filter { $0.sourceLineNumber > 0 }
        currentLine = lines[safe: editor.currentLineNumber - 1] ?? Song.Section.Line(sourceLineNumber: editor.totalLineNumbers)
    }
}
