import SwiftUI

struct MainView: View {
    @Binding var document: ChordProDocument
    @Binding var diagrams: [Diagram]
    @State var song = Song()
    @AppStorage("showEditor") var showEditor: Bool = false
    @AppStorage("showChords") var showChords: Bool = true
    @AppStorage("pathSongs") var pathSongs: String = GetDocumentsDirectory()

    var body: some View {
        NavigationView {
            FileBrowser()
            HSplitView() {
                ZStack{
                    //FancyBackground()
                    VStack() {
                        HeaderView(song: $song).background(Color.accentColor.opacity(0.3)).padding(.bottom)
                        SongView(song: $song).frame(minWidth: 400)
                    }.frame(minWidth: 400)
                }
                if showEditor {
                    EditorView(document: $document, diagrams: $diagrams, song: $song)
                        .font(.custom("HelveticaNeue", size: 14))
                        .frame(minWidth: 400)
                        .background(Color(NSColor.textBackgroundColor))
                }
            }
            .toolbar {
                ToolbarItem() {
                    Button(action: {
                        withAnimation {
                            showChords.toggle()
                    }
                    } ) {
                        HStack {
                            Image(systemName: showChords ? "number.square.fill" : "number.square")
                            Text(showChords ? "Hide chords" : "Show chords")
                        }
                    }
                }
                ToolbarItem() {
                    Button(action: {
                        withAnimation {
                            showEditor.toggle()
                    }
                    } ) {
                        HStack {
                            Image(systemName: showEditor ? "pencil.circle.fill" : "pencil.circle")
                            Text(showEditor ? "Hide editor" : "Edit song")
                            
                        }
                    }
                }

            }
        }
        .onAppear(
            perform: {
                song = ChordPro.parse(document: document, diagrams: diagrams)
                print("MainView: ready")
            }
        )
        .onChange(of: document.text) { newValue in
            song = ChordPro.parse(document: document, diagrams: diagrams)
            print("MainView: Text is changed")
        }
    }
}
