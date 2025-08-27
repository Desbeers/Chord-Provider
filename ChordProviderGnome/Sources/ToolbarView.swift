import Adwaita

struct ToolbarView: View {

    @State private var about = false
    var app: AdwaitaApp
    var window: AdwaitaWindow

    var view: Body {
        HeaderBar.end {
            Menu(icon: .default(icon: .openMenu)) {
                MenuButton(Loc.newWindow, window: false) {
                    app.addWindow("main")
                }
                .keyboardShortcut("n".ctrl())
                MenuButton(Loc.closeWindow) {
                    window.close()
                }
                .keyboardShortcut("w".ctrl())
                MenuSection {
                    MenuButton("About Chord Provider", window: false) {
                        about = true
                    }
                }
            }
            .primary()
            .tooltip(Loc.mainMenu)
            .aboutDialog(
                visible: $about,
                app: "Chord Provider",
                developer: "Nick Berendsen",
                version: "dev",
                icon: .custom(name: "io.github.AparokshaUI.AdwaitaTemplate"),
                website: .init(string: "https://github.com/Desbeers/Chord-Provider")!,
                issues: .init(string: "https://github.com/Desbeers/Chord-Provider/issues")!
            )
        }
    }

}
