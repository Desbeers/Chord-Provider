import SwiftUI

struct MainView: View {
    @Binding var document: ChordProDocument
    let diagrams: [Diagram]
    @State var song = Song()
    @AppStorage("showEditor") var showEditor: Bool = false
    @AppStorage("showChords") var showChords: Bool = true
    @Environment(\.colorScheme) var colorScheme

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
        .modifier(AppAppearanceModifier())
        .onAppear(
            perform: {
                song = ChordPro.parse(document: document, diagrams: diagrams)
            }
        )
        .onChange(of: colorScheme) {color in
            /// Get the correct colors
            song = ChordPro.parse(document: document, diagrams: diagrams)
        }
        .onChange(of: document.text) { newValue in
            song = ChordPro.parse(document: document, diagrams: diagrams)
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
                AppAppearanceSwitch()
            }
        }
    }
}
