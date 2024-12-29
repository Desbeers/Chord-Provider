//
//  View+extension.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen//

import SwiftUI

extension View {

    /// Find the NSWindow of the scene
    /// - Parameter callback: The optional `NSWindow`
    /// - Returns: A SwiftUI `background` View
    func withHostingWindow(_ callback: @escaping (NSWindow?) -> Void) -> some View {
        self.background(NSWindow.HostingWindowFinder(callback: callback))
    }
}
