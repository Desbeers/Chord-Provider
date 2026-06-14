//
//  SettingsView+options.swift
//  Chord Provider
//
//  © 2026 Nick Berendsen
//

import SwiftUI

extension SettingsView {

    /// `View` with song options
    @ViewBuilder var options: some View {
        @Bindable var appState = appState
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading) {
                    appState.repeatWholeChorusToggle
                    appState.lyricsOnlyToggle
                }
                .wrapSettingsSection(title: "Display Options")
                .padding(.bottom)
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}
