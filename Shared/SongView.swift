import SwiftUI

struct SongView: View {
    @Binding var song: Song
    
    @AppStorage("showEditor") var showEditor: Bool = false
    @AppStorage("showMetronome") var showMetronome: Bool = false
    @AppStorage("showChords") var showChords: Bool = true
    
    var body: some View {
        VStack {
            HtmlView(html: (song.html ?? ""))
        }
        
    }
}


