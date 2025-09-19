//
//  Backport.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

/// Backport `SwiftUI` functions
public struct Backport<Content> {
    /// The content
    public let content: Content
    /// Init
    public init(_ content: Content) {
        self.content = content
    }
}

extension View {

    /// Backport `SwiftUI` functions
    var backport: Backport<Self> { Backport(self) }
}

extension Backport where Content: View {
    /// Backport `glassEffect`
    @ViewBuilder func glassEffect() -> some View {
        if #available(macOS 26, *) {
            content.glassEffect()
        } else {
            content
        }
    }
}
