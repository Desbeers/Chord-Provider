//
//  ChordProEditorDelegate.swift
//  Chord Provider
//
//  © 2026 Nick Berendsen
//

import Foundation

/// The delegate for the ``ChordProEditor``
protocol ChordProEditorDelegate: AnyObject {

    /// A delegate function to update a view
    @MainActor func selectionNeedsDisplay()
}
