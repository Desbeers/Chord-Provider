import SwiftUI

struct EditorView: View {
    
    @Binding var document: ChordProDocument
    
    var body: some View {
        TextEditor(text: $document.text)
            .font(.custom("HelveticaNeue", size: 14))
            .padding()
    }
}
