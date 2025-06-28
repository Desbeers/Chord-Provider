//
//  Backport.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

public struct Backport<Content> {
    public let content: Content

    public init(_ content: Content) {
        self.content = content
    }
}

extension View {
    var backport: Backport<Self> { Backport(self) }
}

extension Backport where Content: View {
    @ViewBuilder func glassEffect() -> some View {
        if #available(macOS 26, *) {
            content.glassEffect()
        } else {
            content
        }
    }
}
