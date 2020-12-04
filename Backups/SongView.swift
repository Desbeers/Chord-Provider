//
//  RealView.swift
//  Make chords (macOS)
//
//  Created by Nick Berendsen on 29/11/2020.
//

import SwiftUI

struct SongView2: View {
    //var name: String
    @Binding var text: String
    @AppStorage("showEditor") var showEditor: Bool = false
    
    var body: some View {
        HtmlView(text: $text)
        .toolbar {
            ToolbarItem() {
                Button(action: {
                    withAnimation {
                        showEditor.toggle()
                }
                } ) {
                    HStack {
                        Image(systemName: "pencil").foregroundColor(.accentColor)
                        Text(showEditor ? "Hide editor" : "Edit song")
                        
                    }
                }
            }
        }
    }
}

struct SongView: View {
    var song = Song()
    @AppStorage("showEditor") var showEditor: Bool = false
    @AppStorage("pathSongs") var pathSongs: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    
    @State var fontSize : CGFloat = 14
    
    var body: some View {
        //let rows = [
        //    GridItem(.adaptive(minimum: 50))
        //]
        VStack() {
            //LazyHGrid(rows: rows,spacing: 0) {
            ForEach(song.sections) { section in
                HStack(alignment: .top) {
                    SectionView(name: section.name != nil ? section.name! : " ", fontSize: fontSize)
                    VStack(alignment: .leading) {
                        ForEach(section.lines) { line in
                            if line.plain != nil {
                                PlainView(text: line.plain!, fontSize: fontSize)
                            }
                            else if line.comment != nil {
                                CommentView(text: line.comment!, fontSize: fontSize)
                            }
                            else if line.tablature != nil {
                                TablatureView(text: line.tablature!, fontSize: fontSize)
                            }
                            else if !(line.measures.isEmpty) {
                                MeasuresView(measures: line.measures, fontSize: fontSize)
                            }
                            else {
                                PartsView(parts: line.parts, fontSize: fontSize)
                            }
                        }
                    }
                }
                Divider()
            }
        }.padding()

        .gesture(MagnificationGesture()
            .onChanged { value in
                //if fontSize >= 6 && fontSize <= 32 {
                    fontSize = value.magnitude * 14
                //}
            }
        )
        .toolbar {
            ToolbarItem() {
                Button(action: {
                    withAnimation {
                        showEditor.toggle()
                }
                } ) {
                    HStack {
                        Image(systemName: "pencil")
                        Text(showEditor ? "Hide editor" : "Edit song")
                        
                    }
                }
            }
            #if os(macOS)
            ToolbarItem() {
                
                HStack {
                Image(systemName: "minus")
                    Slider(value: $fontSize, in: 6...32, step: 1).frame(width:100)
                Image(systemName: "plus")
                    
                }
            }
            #endif
        }
    }
}

struct SectionView: View {
    var name: String
    var fontSize: CGFloat
    
    var body: some View {
        Text(name).font(.system(size: fontSize)).fontWeight(.bold).padding(.horizontal).frame(alignment: .trailing)
    }
}

struct PlainView: View {
    var text: String
    var fontSize: CGFloat
    
    var body: some View {
        Text(text).font(.system(size: fontSize))
    }
}

struct CommentView: View {
    var text: String
    var fontSize: CGFloat
    
    var body: some View {
        Text(text).italic().foregroundColor(.secondary).padding().font(.system(size: fontSize))
    }
}

struct TablatureView: View {
    var text: String
    var fontSize: CGFloat
    
    var body: some View {
        Text(text).font(.system(size: fontSize)).font(.system(.body, design: .monospaced))
    }
}

struct MeasuresView: View {
    var measures = [Measure]()
    var fontSize: CGFloat
    
    var body: some View {
        HStack() {
            ForEach(measures) { measure in
                Image(systemName: "poweron")
                ForEach(measure.chords, id: \.self) { chord in
                    Text(chord).foregroundColor(.accentColor).font(.system(size: fontSize))
                }
            }
        }
    }
}

struct PartsView: View {
    var parts = [Part]()
    var fontSize: CGFloat
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(parts) { part in
                VStack(alignment: .leading, spacing: 0) {
                    if part.chord != "" {
                        Text(part.chord!)
                            .foregroundColor(.accentColor)
                            .font(.system(size: fontSize))
                    }
                    else {
                        /// Fill the space
                        Text(" ").font(.system(size: fontSize))
                    }
                    Text(part.lyric!).font(.system(size: fontSize))
                }
            }

        }
    }
}


