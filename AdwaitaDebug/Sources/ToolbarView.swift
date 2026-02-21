import Adwaita

struct ToolbarView: View {

    var app: AdwaitaApp
    var window: AdwaitaWindow

    @Binding var appState: AppState

    @Binding var showPreferencesDialog: Bool

    @State private var about = false
    @State private var shortcuts = false

    var view: Body {
        HeaderBar.end {
            content
                .aboutDialog(
                    visible: $about,
                    app: "AdwaitaTemplate",
                    developer: "david-swift",
                    version: "dev",
                    icon: .custom(name: "io.github.AparokshaUI.AdwaitaTemplate"),
                    website: .init(string: "https://git.aparoksha.dev/aparoksha/adwaita-template")!,
                    issues: .init(string: "https://git.aparoksha.dev/aparoksha/adwaita-template/issues")!
                )
                .shortcutsDialog(visible: $shortcuts)
                .shortcutsSection { section in
                    section
                        .shortcutsItem(Loc.newWindow, accelerator: "n".ctrl())
                        .shortcutsItem(Loc.closeWindow, accelerator: "w".ctrl())
                        /// This needs `control` `shift` and `+`
                        .shortcutsItem("Larger Font", accelerator: "plus".ctrl())
                        .shortcutsItem("Smaller Font", accelerator: "minus".ctrl())
                        .shortcutsItem(Loc.quitShortcut, accelerator: "q".ctrl())
                        .shortcutsItem(Loc.keyboardShortcuts, accelerator: "question".ctrl())
                }
        }
    }

    var content: AnyView {
        Menu(icon: .default(icon: .openMenu)) {
            MenuButton(Loc.newWindow, window: false) {
                app.addWindow("main")
            }
            .keyboardShortcut("n".ctrl())
            MenuSection {
                Submenu("Font Size") {
                    MenuButton("Larger") {
                        appState.theme.editorFontSize = min(appState.theme.editorFontSize + 1, 20)
                    }
                    /// This needs `control` `shift` and `+`
                    .keyboardShortcut("plus".ctrl())
                    /// This needs `control` and `+` only :-)
                    .keyboardShortcut("equal".ctrl())
                    MenuButton("Smaller") {
                        appState.theme.editorFontSize = max(appState.theme.editorFontSize - 1, 8)
                    }
                    .keyboardShortcut("minus".ctrl())
                    MenuSection {
                        MenuButton("Reset Font") {
                            appState.theme.editorFontSize = 12
                        }
                        .keyboardShortcut("0".ctrl())
                    }
                }
            }
            MenuButton("Preferences", window: false) {
                showPreferencesDialog = true
            }
            MenuSection {
                MenuButton(Loc.keyboardShortcuts, window: false) {
                    shortcuts = true
                }
                .keyboardShortcut("question".ctrl())
                MenuButton(Loc.about, window: false) {
                    about = true
                }
            }
        }
        .primary()
        .tooltip(Loc.mainMenu)
    }

}
