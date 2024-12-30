//
//  HelpButtons.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

/// SwiftUI `Buttons` for help
struct HelpButtons: View {
    /// Environment to open windows
    @Environment(\.openWindow) private var openWindow
    /// The body of the `View`
    var body: some View {
        Button(AppDelegate.WindowID.helpView.rawValue) {
            openWindow(id: AppDelegate.WindowID.helpView.rawValue)
        }
        Divider()
        if let url = URL(string: "https://github.com/Desbeers/Chord-Provider") {
            Link(destination: url) {
                Text("Chord Provider on GitHub")
            }
        }
    }
}
