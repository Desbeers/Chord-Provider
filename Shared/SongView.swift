import SwiftUI

struct SongView: View {
    var song: Song
    
    @AppStorage("showEditor") var showEditor: Bool = false
    @AppStorage("showChords") var showChords: Bool = true
    
    var body: some View {
        /// Stupid hack to ge the view using full height
        GeometryReader { g in
            ScrollView {
                HStack {
                    HtmlView(html: (song.html ?? "")).frame(height: g.size.height)
                    if showChords {
                        HtmlView(html: (song.htmlchords ?? "leeg")).frame(width: 140,height: g.size.height)
                    }
                }
            }.frame(height: g.size.height)
        }
    }
}
