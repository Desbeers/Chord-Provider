//
//  File.swift
//  ChordProvider
//
//  Created by Nick Berendsen on 01/09/2025.
//

import Foundation
import Adwaita
import ChordProviderCore

/// The settings for the application
struct AppSettings: Codable {
    init() {
        if let settings = try? SettingsCache.get(id: "ChordProviderGnome", struct: AppSettings.self) {
            print("Loaded settings")
            self = settings
        } else {
            print("No settings found, creating new one")
        }
    }
    
    /// Core settings
    var core = ChordProviderSettings() {
        didSet {
            print("Saving settings")
            try? SettingsCache.set(id: "ChordProviderGnome", object: self)
        }
    }
    /// Application specific settings
    var app = App()
    /// Editor specific settings
    var editor = Editor() {
        didSet {
            print("Saving settings")
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
    }
}

extension AppSettings {

    /// Settings for the application
    struct App {
        /// The source of the song
        var source = sampleSong
        /// The original source of the song when opened or created
        var originalSource = sampleSong
        /// A signal to open a song
        var openSong = Signal()
        /// A signal to save as song with a new name
        var saveSongAs = Signal()
        /// Show the *About* dialog
        var aboutDialog = false
        /// Show the *Transpose* dialog
        var transposeDialog = false
        /// Bool if the song is  *Transposed*
        var isTransposed = false
        /// The position of the splitter``
        var splitter: Int = 0
        /// Bool if the editor is shown
        var showEditor: Bool = false
        /// Bool if the preferences is shown
        var showPreferences: Bool = false
        /// The zoom factor
        var zoom: Double = 1
        /// Show a toast
        var showToast = Signal()
        /// The toast message
        var toastMessage: String = ""
    }
}

extension AppSettings {

    struct Editor: Codable {
        var showLineNumbers: Bool = true
        var wrapLines: Bool = true
        var fontSize: EditorFont = .standard
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
