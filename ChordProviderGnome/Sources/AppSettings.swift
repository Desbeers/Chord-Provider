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
struct AppSettings {
    /// Core settings
    var core = ChordProviderSettings()
    /// Application specific settings
    var app = App()
    /// The subtitle for the application
    var subtitle: String {
        "\(core.songURL?.deletingPathExtension().lastPathComponent ?? "New Song")\(dirty ? " - edited" : "")"
    }
    /// Bool if the source is modified
    /// - Note: Comparing the source with the original source
    var dirty: Bool {
        app.source != app.originalSource
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
        /// The zoom factor
        var zoom: Double = 1
        /// Show a toast
        var showToast = Signal()
        /// The toast message
        var toastMessage: String = ""
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
