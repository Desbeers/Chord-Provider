//
//  AppState.swift
//  SourceViewDemo
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import SourceView

@MainActor
struct AppState {
    var controller = SourceViewController()
    var editor = SourceViewBridge()
    var options = SourceViewOptions()

    var lastUpdate = Date.now

    var openFile = Signal()

    var fileURL: URL?

    var monoSpaceFont: Bool = true

    var spelling: Bool = true
}
