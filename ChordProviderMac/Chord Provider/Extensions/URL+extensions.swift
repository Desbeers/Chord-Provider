//
//  URL+extensions.swift
//  Chord Provider
//
//  © 2026 Nick Berendsen
//

import AppKit

extension URL {

    /// Open an URL in the Finder
    func openInFinder() {
        NSWorkspace.shared.activateFileViewerSelecting([self])
    }
}

extension URL {

    /// Check if an URL exists
    /// - Returns: True of false
    var exist: Bool {
        FileManager.default.fileExists(atPath: self.path(percentEncoded: false))
    }
}
