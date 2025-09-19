//
//  ChordProEditorDelegate.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

/// The delegate for the ``ChordProEditor``
protocol ChordProEditorDelegate: AnyObject {

    /// A delegate function to update a view
    @MainActor func selectionNeedsDisplay()
}
