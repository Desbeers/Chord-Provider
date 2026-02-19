//
//  AppSettings+Editor.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension AppSettings {

    /// Settings for the source editor
    struct Editor: Codable, Equatable {
        /// Bool if the editor is shown
        var showEditor: Bool = false
        /// Bool if the editor is showing line numbers
        var showLineNumbers: Bool = true
        /// Bool if the editor should wrap lines
        var wrapLines: Bool = true
        /// The position of the splitter``
        var splitter: Int = 400
    }
}


