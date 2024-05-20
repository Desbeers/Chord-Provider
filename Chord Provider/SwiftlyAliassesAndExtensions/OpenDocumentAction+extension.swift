//
//  OpenDocumentAction+extension.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

#if os(macOS)

import SwiftUI

/// Suppress concurrency warnings
extension OpenDocumentAction: @unchecked Sendable {}

#endif
