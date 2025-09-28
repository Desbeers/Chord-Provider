//
//  AppSettings.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

/// The settings for the application
struct AppSettings: Codable {
    init() {
        if var settings = try? SettingsCache.get(id: "ChordProviderGnome", struct: AppSettings.self) {
            print("Loaded settings")
            /// Restore the splitter position when the editor is open
            if settings.editor.showEditor {
                settings.editor.splitter = settings.editor.restoreSplitter
            }
            self = settings
        } else {
            print("No settings found, creating new one")
        }
        /// Open an optional song URL
        if let fileURL = CommandLine.arguments[safe: 1] {
            let url = URL(filePath: fileURL)
            if let content = try? String(contentsOf: url, encoding: .utf8) {
                self.app.source = content
                self.app.originalSource = content
                self.core.songURL = url
                /// Append to recent
                self.app.addRecentSong(songURL: url)
                /// Save it
                try? SettingsCache.set(id: "ChordProviderGnome", object: self)
            }
        }
        if app.source.isEmpty {
            editor.showEditor = false
            editor.splitter = 0
            app.showWelcome = true
        }
    }

    /// Core settings
    var core = ChordProviderSettings() {
        didSet {
            print("Saving core settings")
            try? SettingsCache.set(id: "ChordProviderGnome", object: self)
        }
    }
    /// Application settings
    var app = App() {
        didSet {
            print("Saving app settings")
            try? SettingsCache.set(id: "ChordProviderGnome", object: self)
        }
    }
    /// Editor settings
    var editor = Editor() {
        didSet {
            print("Saving editor settings")
            try? SettingsCache.set(id: "ChordProviderGnome", object: self)
        }
    }
    /// The subtitle for the application
    var subtitle: String {
        "\(core.songURL?.deletingPathExtension().lastPathComponent ?? "New Song")\(dirty ? " - edited" : "")"
    }
    /// Bool if the source is modified
    /// - Note: Comparing the source with the original source
    var dirty: Bool {
        app.source != app.originalSource
    }
    enum CodingKeys: CodingKey {
        case core
        case editor
        case app
    }
}

extension AppSettings {

    /// Settings for the application
    struct App: Codable {
        var id: UUID = UUID()
        /// The source of the song
        var source = ""
        /// The original source of the song when opened or created
        var originalSource = ""
        /// A signal to open a song
        var openSong = Signal()
        /// A signal to save as song with a new name
        var saveSongAs = Signal()
        /// What to do when a song is saved
        var saveDoneAction: SaveDoneAction = .noAction
        /// Show the *About* dialog
        var aboutDialog = false
        /// Show the *Transpose* dialog
        var transposeDialog = false
        /// Bool if the song is  *Transposed*
        var isTransposed = false
        /// Bool if the welcome is shown
        var showWelcome: Bool = false
        /// Bool if the preferences is shown
        var showPreferences: Bool = false
        /// Bool if the close dialog is shown
        var showDirtyClose: Bool = false
        /// The zoom factor
        var zoom: Double = 1
        /// Show a toast
        var showToast = Signal()
        /// The toast message
        var toastMessage: String = ""
        /// Recent songs
        private(set) var recentSongs: [URLElement] = []
        /// The Coding Keys
        enum CodingKeys: CodingKey {
            case zoom
            case recentSongs
        }
        mutating func addRecentSong(songURL: URL) {
            var recent = self.recentSongs
            recent.removeAll { $0.url == songURL }
            recent.insert(URLElement(url: songURL), at: 0)
            self.recentSongs = Array(recent.prefix(100))
        }
        mutating func clearRecentSongs() {
            self.recentSongs = []
        }
    }
}

extension AppSettings {

    /// Settings for the editor
    struct Editor: Codable {
        /// Bool if the editor is shown
        var showEditor: Bool = false
        /// Bool if the editor is showing line numbers
        var showLineNumbers: Bool = true
        /// Bool if the editor should wrap lines
        var wrapLines: Bool = true
        /// The font size of the editor
        var fontSize: EditorFont = .standard
        /// The position of the splitter``
        var splitter: Int = 0 {
            willSet {
                if newValue > 100 {
                    restoreSplitter = newValue
                }
            }
            didSet {
                if splitter < 100 {
                    showEditor = false
                    splitter = 0
                }
            }
        }
        /// Remember the splitter position when hiding the editor
        var restoreSplitter: Int = 400
    }
}

extension AppSettings {
    struct URLElement: Identifiable, Codable{

        var id = UUID()
        var url: URL

    }
}

extension AppSettings {

    enum SaveDoneAction {
        case close
        case openSong
        case noAction
    }
}

extension AppSettings {
    enum EditorFont: Int, Codable, CaseIterable, CustomStringConvertible, Identifiable {
        case smaller = 10
        case small = 11
        case standard = 12
        case large = 13
        case larger = 14

        public var description: String {
            switch self {
            case .smaller: "Smaller"
            case .small: "Small"
            case .standard: "Standard"
            case .large: "Large"
            case .larger: "Larger"
            }
        }
        public var id: Self { self }
    }
}

extension AppSettings {

    enum Font {
        case title
        case subtitle
        case standard
        case chord
        case comment
        case tab
        case grid
        case sectionHeader
        case repeatChorus

        static let base: Double = 12.5

        func style(zoom: Double) -> String {
            switch self {
            case .standard:
                Pango.font(AppSettings.Font.base * zoom)
            case .chord:
                AppSettings.Font.standard.style(zoom: zoom) + Pango.color(HexColor.chord) + Pango.bold.rawValue
            case .comment:
                AppSettings.Font.standard.style(zoom: zoom) + Pango.italic.rawValue + Pango.color(HexColor.comment) + Pango.bold.rawValue
            case .tab:
                AppSettings.Font.standard.style(zoom: zoom) + Pango.monospace.rawValue
            case .grid:
                AppSettings.Font.chord.style(zoom: zoom)
            case .sectionHeader:
                Pango.font(self.size(zoom: zoom)) + Pango.bold.rawValue
            case .title:
                Pango.font(self.size(zoom: zoom)) + Pango.bold.rawValue
            case .subtitle:
                Pango.font(self.size(zoom: zoom))
            case .repeatChorus:
                AppSettings.Font.sectionHeader.style(zoom: zoom) + Pango.italic.rawValue
            }
        }

        func size(zoom: Double) -> Double {
            switch self {
            case .standard, .chord, .comment, .tab, .grid:
                AppSettings.Font.base * zoom
            case .sectionHeader, .subtitle, .repeatChorus:
                AppSettings.Font.base * zoom * 1.2
            case .title:
                AppSettings.Font.base * zoom * 1.4
            }
        }
    }
}
