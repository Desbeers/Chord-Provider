//  MARK: - View: Main View for macOS

/// The main view; on the right of the sidebar.

import SwiftUI

struct MainView: View {
    @Binding var document: ChordProDocument
    let diagrams: [Diagram]
    @State var song = Song()
    @AppStorage("showEditor") var showEditor: Bool = false
    @AppStorage("showChords") var showChords: Bool = true
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HSplitView() {
            VStack() {
                HeaderView(song: song).background(Color.accentColor.opacity(0.3)).padding(.bottom)
                SongView(song: song).frame(minWidth: 400)
                    .frame(minWidth: 400)
            }
            if showEditor {
                EditorView(document: $document)
                    .font(.custom("HelveticaNeue", size: 14))
                    .frame(minWidth: 400)
                    .background(Color(NSColor.textBackgroundColor))
                    .transition(.scale)
            }
        }
        /// Hard-coded the foregroundColor because SwiftUI is buggy when switching appearance.
        /// Not great; the buttons don't dim when the application is in the background.
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
                    .foregroundColor(.secondary)
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
                    .foregroundColor(.secondary)
                }
            }
            ToolbarItem(placement: .navigation) {
                Button(action: {
                    NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
                } ) {
                    Image(systemName: "sidebar.left").foregroundColor(.secondary)
                }
            }
        }
        .modifier(AppAppearanceModifier())
        .modifier(SongViewModifier(document: $document, song: $song, diagrams: diagrams))
    }
}
