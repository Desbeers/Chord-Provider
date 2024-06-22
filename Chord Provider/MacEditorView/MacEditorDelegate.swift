//
//  MacEditorDelegate.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

/// The delegate for the ``ChordProEditor``
// swiftlint:disable:next class_delegate_protocol
protocol MacEditorDelegate {

    /// A delegate function to update a view
    @MainActor
    func selectionNeedsDisplay()
}
