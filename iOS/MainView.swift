import SwiftUI

struct MainView: View {
    @Binding var document: ChordProDocument
    let diagrams: [Diagram]
    @State var song = Song()
    @AppStorage("showEditor") var showEditor: Bool = false
    @AppStorage("showChords") var showChords: Bool = true
    @AppStorage("appTheme") var appTheme: String = "Light"
    
    @Environment(\.colorScheme) var colorScheme
    
    enum DisplayMode: Int {
        case system = 0
        case dark = 1
        case light = 2
    }

    @AppStorage("displayMode") var displayMode: DisplayMode = .system

    func overrideDisplayMode() {
        var userInterfaceStyle: UIUserInterfaceStyle
        
        switch displayMode {
        case .dark: userInterfaceStyle = .dark
        case .light: userInterfaceStyle = .light
        case .system: userInterfaceStyle = UITraitCollection.current.userInterfaceStyle
        }
        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = userInterfaceStyle
        appTheme = (colorScheme == .dark ? "Dark" : "Light")
    }

    var body: some View {
        VStack() {
            HeaderView(song: song).background(Color.purple.opacity(0.3)).padding(.bottom)
            HStack {
                SongView(song: song)
                if showEditor {
                    EditorView(document: $document)
                }
            }
        }
        .statusBar(hidden: true)
        .onAppear(
            perform: {
                song = ChordPro.parse(document: document, diagrams: diagrams)
                print("'" + (song.title ?? "no title") + "' is ready")
            }
        )
        .onAppear(perform: overrideDisplayMode)
        .onChange(of: document.text) { newValue in
            song = ChordPro.parse(document: document, diagrams: diagrams)
        }
        .onChange(of: appTheme) { newValue in
            /// Get the correct colors
            song = ChordPro.parse(document: document, diagrams: diagrams)
            print("Change of theme")
        }
        /// iPhone shows only one ToolbarItem; that's ok because I only like the first item for iPhone anyway :-)
        .toolbar {
            ToolbarItem() {
                Button(action: {
                    withAnimation {
                        showChords.toggle()
                }
                } ) {
                    Image(systemName: showChords ? "number.square.fill" : "number.square")

                }
            }
            ToolbarItem() {
                Button(action: {
                    withAnimation {
                        showEditor.toggle()
                }
                } ) {
                    Image(systemName: showEditor ? "pencil.circle.fill" : "pencil.circle")

                }
            }
            ToolbarItem() {
                Picker("Color", selection: $displayMode) {
                    Text("System").tag(DisplayMode.system)
                    Text("Light").tag(DisplayMode.light)
                    Text("Dark").tag(DisplayMode.dark)
                }
                .pickerStyle(SegmentedPickerStyle())
                .onReceive([self.displayMode].publisher.first()) { _ in
                    overrideDisplayMode()
                }
            }
        }
    }
}
