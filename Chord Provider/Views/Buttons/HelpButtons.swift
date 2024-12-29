//
//  HelpButtons.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

struct HelpButtons: View {
    /// Environment to open windows
    @Environment(\.openWindow) private var openWindow
    /// The body of the `View`
    var body: some View {
        Button(AppDelegateModel.WindowID.helpView.rawValue) {
            openWindow(id: AppDelegateModel.WindowID.helpView.rawValue)
        }
        Divider()
        if let url = URL(string: "https://github.com/Desbeers/Chord-Provider") {
            Link(destination: url) {
                Text("Chord Provider on GitHub")
            }
        }
    }
}
