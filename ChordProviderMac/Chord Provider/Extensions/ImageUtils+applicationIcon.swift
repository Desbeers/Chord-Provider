//
//  ImageUtils+applicationIcon.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import ChordProviderCore

extension ImageUtils {

    /// Get the application icon
    static func applicationIcon() -> Image {
        Image(nsImage: NSImage(named: "AppIcon") ?? NSImage())
    }
}
