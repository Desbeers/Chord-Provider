//
//  AppState.swift
//  Chord Provider (macOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI

/// The observable app state for Chord Provider
@Observable
final class AppState {
    /// The Chord Provider settings
    var settings: ChordProviderSettings {
        didSet {
            ChordProviderSettings.save(settings: settings)
        }
    }
    /// Init the class; get Chord Provider settings
    init() {
        self.settings = ChordProviderSettings.load()
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
            Toggle(isOn: $appState.settings.general.repeatWholeChorus) {
                Text("Repeat whole chorus")
                Text("When enabled, the **{chorus}** directive will be replaced by the whole last found chorus with the same label.")
            }
        }
    }
}
