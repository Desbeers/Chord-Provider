//
//  SettingsView+options.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension SettingsView {

    /// `View` with song options
    @ViewBuilder var options: some View {
        @Bindable var appState = appState
        ScrollView {
            VStack(alignment: .leading) {
                appState.repeatWholeChorusToggle
                appState.lyricsOnlyToggle
            }
            .wrapSettingsSection(title: "Display Options")
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}
