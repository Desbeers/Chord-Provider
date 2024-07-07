//
//  HelpButtonsView.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 22/06/2024.
//

import SwiftUI

struct HelpButtonsView: View {
    /// The scene state in the environment
    @FocusedValue(\.sceneState) private var sceneState: SceneState?
    /// The body of the `View`
    var body: some View {
        if let sampleSong = Bundle.main.url(forResource: "Swing Low Sweet Chariot", withExtension: "chordpro") {
            Button("Insert a Song Example") {
                if
                    let sceneState,
                    let textView = sceneState.editorInternals.textView,
                    let content = try? String(contentsOf: sampleSong, encoding: .utf8) {
                    textView.replaceText(text: content)
                }
            }
            .disabled(sceneState == nil)
        }
        Divider()
        if let url = URL(string: "https://github.com/Desbeers/Chord-Provider") {
            Link(destination: url) {
                Text("Chord Provider on GitHub")
            }
        }
    }
}
