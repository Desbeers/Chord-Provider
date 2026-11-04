//
//  OptionsView.swift
//  SourceViewDemo
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import SourceView

/// The options `View` for the application
struct OptionsView: View {

    /// The state of the application
    @Binding var appState: AppState
    /// The main `View`
    var view: Body {
        VStack(spacing: 10) {
            Text(appState.editor.language ?? "Unknown Language")
            SwitchRow()
                .title("Line Numbers")
                .subtitle("Show the line numbers in the editor")
                .active($appState.options.showLineNumbers)
            SwitchRow()
                .title("Wrap Lines")
                .subtitle("Wrap lines when they are too long")
                .active($appState.options.wrapLines)
            SwitchRow()
                .title("Highlight")
                .subtitle("Higlight the current line")
                .active($appState.options.highlightCurrentLine)
            SwitchRow()
                .title("Spelling")
                .subtitle("Check the spelling")
                .active($appState.spelling)
            SwitchRow()
                .title("Font")
                .subtitle("Use monospace font")
                .active($appState.monoSpaceFont)
            SpinRow(
                "",
                value: $appState.options.fontSize,
                min: 80,
                max: 120
            )
            .suffix {
                Text("%")
            }
        }
        .halign(.center)
        .padding()
    }
}
