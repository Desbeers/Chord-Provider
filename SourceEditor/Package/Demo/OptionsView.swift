//
//  OptionsView.swift
//  SourceEditorDemo
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import SourceEditor

/// The options `View` for the application.
struct OptionsView: View {

    /// The state of the application.
    @Binding var appState: AppState
    /// Bool to open the style dialog.
    @State var styleDialog: Bool = false
    /// The main `View`.
    var view: Body {
        VStack {
            ScrollView {
                Text(appState.options.language.display)
                    .heading()
                    .padding(.top)
                Form {
                    SwitchRow()
                        .title("Editable")
                        .subtitle("Make the text editable")
                        .active($appState.options.editable)
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
                        .subtitle("Highlight the current line")
                        .active($appState.options.highlightCurrentLine)
                    SwitchRow()
                        .title("Spelling")
                        .subtitle("Check the spelling")
                        .active($appState.options.spelling)
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
                Button(appState.options.scheme.display) {
                    styleDialog.toggle()
                }
                .tooltip(appState.options.scheme.description)
                .padding(.top)
                .halign(.center)
                .valign(.center)
                .dialog(visible: $styleDialog) {
                    Form {
                        EditorSchemePicker(controller: appState.controller, customOnly: false)
                            .padding(.bottom)
                        SwitchRow()
                            .title("Dynamic recolering")
                            .subtitle("Recoler the window with the theme colors.")
                            .active($appState.options.colorfullWindow)
                    }
                    .topToolbar {
                        HeaderBar.empty()
                            .headerBarTitle {
                                WindowTitle(
                                    subtitle: appState.options.scheme.display,
                                    title: "Select a Theme"
                                )
                            }
                    }
                }
                .hexpand()
                .vexpand()
                .halign(.center)
            }
        }
    }
}
