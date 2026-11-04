//
//  AppState.swift
//  SourceViewDemo
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import SourceView

/// State of the application
@MainActor
struct AppState {

    /// The controller.
    var controller = SourceViewController()
    /// The editor bridge.
    var editor = SourceViewBridge()
    /// Editor options.
    var options = SourceViewOptions()
    /// Last update of the content.
    var lastUpdate = Date.now
    /// Signal to open the file dialog.
    var openFile = Signal()
    /// The current file
    var fileURL: URL?
    /// Bool to use a monospace font
    var monoSpaceFont: Bool = true
}
