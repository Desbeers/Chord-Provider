//
//  PreviewState.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

/// The state of a PDF preview
struct PreviewState: Equatable {
    /// The optional data for a preview
    var data: Data?
    /// Bool if the preview is outdated
    var outdated: Bool = false
}
