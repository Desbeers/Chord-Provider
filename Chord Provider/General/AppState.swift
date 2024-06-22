//
//  AppState.swift
//  Chord Provider (macOS)
//
//  © 2024 Nick Berendsen
//

import SwiftUI

/// The observable app state for Chord Provider
@Observable final class AppState {
    /// The ID of the app state
    var id: String
    /// The Chord Provider settings
    var settings: ChordProviderSettings {
        didSet {
            try? ChordProviderSettings.save(id: id, settings: settings)
        }
    }
    /// Init the class; get Chord Provider settings
    init(id: String) {
        self.id = id
        self.settings = ChordProviderSettings.load(id: id)
    }
}

extension AppState {

    /// SwiftUI `View` with a `Toggle` to show the whole last chorus when using a *{chorus}* directive
    public var repeatWholeChorusToggle: some View {
        RepeatWholeChorusToggle(appState: self)
    }
    /// SwiftUI `View` with a `Toggle` to show the whole last chorus when using a *{chorus}* directive
    struct RepeatWholeChorusToggle: View {
        /// Chord Display Options object
        @Bindable var appState: AppState
        /// The body of the `View`
        var body: some View {
            Toggle(isOn: $appState.settings.songDisplayOptions.repeatWholeChorus) {
                Text("Repeat whole chorus")
                Text("When enabled, the **{chorus}** directive will be replaced by the whole last found chorus with the same label.")
            }
        }
    }
}
