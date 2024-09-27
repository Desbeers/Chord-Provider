//
//  AppStateModel+Elements.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

extension AppStateModel {

    /// SwiftUI `View` with a `Toggle` to show the whole last chorus when using a *{chorus}* directive
    public var repeatWholeChorusToggle: some View {
        RepeatWholeChorusToggle(appState: self)
    }
    /// SwiftUI `View` with a `Toggle` to show the whole last chorus when using a *{chorus}* directive
    struct RepeatWholeChorusToggle: View {
        /// Chord Display Options object
        @Bindable var appState: AppStateModel
        /// The body of the `View`
        var body: some View {
            Toggle(isOn: $appState.settings.songDisplayOptions.general.repeatWholeChorus) {
                Text("Repeat whole chorus")
                Text("When enabled, the **{chorus}** directive will be replaced by the whole last found chorus with the same label.")
            }
        }
    }
}

extension AppStateModel {

    /// SwiftUI `View` with a `Toggle` to show only the lyrics
    public var lyricsOnlyToggle: some View {
        LyricsOnlyToggle(appState: self)
    }
    /// SwiftUI `View` with a `Toggle` to show only the lyrics
    struct LyricsOnlyToggle: View {
        /// Chord Display Options object
        @Bindable var appState: AppStateModel
        /// The body of the `View`
        var body: some View {
            Toggle(isOn: $appState.settings.songDisplayOptions.general.lyricsOnly) {
                Text("Show only lyrics")
                Text("This option will hide all chords.")
            }
        }
    }
}
