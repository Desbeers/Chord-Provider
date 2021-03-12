import SwiftUI

func BuildSong(song: Song) -> String {
    
    var html = """
               <!DOCTYPE html>
               <html lang="en">
               <head>
                 <meta charset="utf-8">
                 <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=yes">
               <style>
               :root {
                 supported-color-schemes: light dark;\n
               """
    /// Add  colors from the assets catalog  to the css
    html += "--accentColor: \(Color.accentHtmlColor);\n"
    html += "--highlightColor: \(Color.highlightHtmlColor);\n"
    html += "--sectionColor: \(Color.sectionHtmlColor);\n"
    html += "--commentBackground: \(Color.commentHtmlBackground);\n"
    html += "}\n"
    /// Add the main CSS
    if let filepath = Bundle.main.path(forResource: "style", ofType: "css") {
        do {
            let contents = try String(contentsOfFile: filepath)
            html += contents
        } catch {
            print(error)
        }
    }
    html += """
            </style>
            </script>
            </head>
            <body>
            <div id="container">
            <div id="grid">
            """
    song.sections.forEach { section in
        html += SectionView(section)
        if !section.lines.isEmpty {
            html += "<div class=\"lines " + (section.type ?? "") + "\">"
            section.lines.forEach { (line) in
                if !line.measures.isEmpty {
                    html += MeasuresView(line)
                } else if line.tablature != nil {
                    html += "<div class=\"tablature\">" +  line.tablature! + "</div>"
                } else if line.comment != nil {
                    html += "<div class=\"comment\">" +  line.comment! + "</div>"
                } else if (section.type == nil) {
                    html += "<div class=\"plain\">"
                    html += PlainView(line)
                    html += "</div>"
                } else {
                    html += PartsView(line)
                }
            }
            html += "</div>"
        }
    }
    html += "</div>"
    html += "</div>"
    html += "</body></html>"

    return html
}

func SectionView(_ section: Sections) -> String {

    var html = ""
    html += "<div class=\"section "
    if section.lines.isEmpty {
        html += "no-name\">&nbsp;</div><div class=\"section single "
    }
    if section.name == nil {
        html += "no-name "
    }
    html += (section.type != nil ? section.type! : "")
    html += "\">"
    html += (section.name != nil ? "<div class=\"name\">" + section.name! + "</div>" : "&nbsp;")
    html += "</div>"
    
    return html
}

func MeasuresView(_ line: Line) -> String {

    var html = "<div class=\"measures\">"
    line.measures.forEach { (measure) in
        html += "<div class=\"measure\">"
        measure.chords.forEach { (chord) in
            html += "<div class=\"chord\">" + chord + "</div>"
        }
        html += "</div>"
    }
    html += "</div>"
    
    return html
}

func PartsView(_ line: Line) -> String {
    
    var html = "<div class=\"line\">"
    line.parts.forEach { (part) in
        html += "<div class=\"part\"><div class=\"chord\">"
        html += (part.chord != "" ? part.chord!: "&nbsp;")
        html += "</div><div class=\"lyric\">\(part.lyric!)</div></div>"
    }
    html += "</div>"
    
    return html
}

func PlainView(_ line: Line) -> String {
    
    var html = "<div class=\"line\">"
    line.parts.forEach { (part) in
        html += "<div class=\"plain\">\(part.lyric!)</div>"
    }
    html += "</div>"
    
    return html
}
