import SwiftUI

struct MainView: View {
    @Binding var document: ChordProDocument
    @Binding var diagrams: [Diagram]
    @State var song = Song()
    @AppStorage("showEditor") var showEditor: Bool = false
    @AppStorage("showChords") var showChords: Bool = true

    var body: some View {
        VStack() {
            HeaderView(song: $song).background(Color.blue.opacity(0.3))
            HStack {
                SongView(song: $song)
                if showEditor {
                    EditorView(document: $document, diagrams: $diagrams, song: $song)
                }
            }
        }
        .onAppear(
            perform: {
                song = ChordPro.parse(document: document, diagrams: diagrams)
                print("MainView: ready")
            }
        )
        /// iPhone shows only one ToolbarItem; that's ok because I only like the first item for iPhone anayway :-)
        .toolbar {
            ToolbarItem() {
                Button(action: {
                    withAnimation {
                        showChords.toggle()
                        /// Rebuild the HTML view with or without chord diagrams
                        song.html = BuildSong(song: song, chords: showChords)
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
        }

    }
}
