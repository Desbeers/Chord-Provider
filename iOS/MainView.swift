//  MARK: - View: Main View for iOS

/// The content of the whole application.

import SwiftUI

struct MainView: View {
    @Binding var document: ChordProDocument
    let diagrams: [Diagram]
    @State var song = Song()
    @AppStorage("showEditor") var showEditor: Bool = false
    @AppStorage("showChords") var showChords: Bool = true
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.horizontalSizeClass) var sizeClass

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
        .modifier(SongViewModifier(document: $document, song: $song, diagrams: diagrams))
        /// iPhone shows only one ToolbarItem; that's ok because I only like the first item for iPhone anyway :-)
        .toolbar {
            ToolbarItem(placement: (sizeClass == .compact ? .bottomBar : .automatic)) {
                AppAppearanceSwitch()
            }
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
        }
    }
}
