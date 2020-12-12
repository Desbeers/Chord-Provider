import SwiftUI

struct EditorView: View {
    
    @Binding var document: ChordProDocument
    @Binding var diagrams: [Diagram]
    @Binding var song: Song
    
    @AppStorage("showChords") var showChords: Bool = true
    
    var body: some View {
        TextEditor(text: $document.text)
            .font(.custom("HelveticaNeue", size: 14))
            .padding()
    }
}
