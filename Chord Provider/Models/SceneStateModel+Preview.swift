//
//  SceneStateModel+Preview.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension SceneStateModel {

    /// The state of a PDF preview
    struct Preview: Equatable {
        /// The optional data for a preview
        var data: Data?
        /// Bool if the preview is outdated
        var outdated: Bool = false
    }
}
