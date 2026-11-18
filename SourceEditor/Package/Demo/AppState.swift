//
//  AppState.swift
//  SourceEditorDemo
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import SourceEditor

/// State of the application
@MainActor
struct AppState {

    /// The controller.
    var controller = Editor.Controller()
    /// The editor bridge.
    var editor = Editor.Bridge()
    /// Editor options.
    var options = Editor.Options()
    /// Last update of the content.
    var lastUpdate = Date.now
    /// Signal to open the file dialog.
    var openFile = Signal()
    /// The current file
    var fileURL: URL?
    /// Bool to use a monospace font
    var monoSpaceFont: Bool = true
}

extension AppState: @MainActor Codable {

    /// Items to save in the database
    enum CodingKeys: String, CodingKey {
        /// Only save the options
        case options
    }
}
