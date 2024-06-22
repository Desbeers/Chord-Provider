//
//  AppDelegate.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import AppKit

/// The AppDelegate for **Chord Provider**
class AppDelegate: NSObject, NSApplicationDelegate {
    /// Don't terminate when the last Chord Provider window is closed
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
}
