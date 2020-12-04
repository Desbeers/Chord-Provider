//
//  BuildHtml.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 03/12/2020.
//

import SwiftUI

func BuildHtml(song: Song) -> String {
    var html = """
               <!DOCTYPE html>
               <html lang="en">
               <head>
                 <meta charset="utf-8">
                 <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=yes">
               <style>
               :root {
                 supported-color-schemes: light dark;
               """
    html += "--accentColor: " + GetAccentColor() + ";"
    html += "--highlightColor: " + GetHighlightColor() + ";"
    html += "}"

    if let filepath = Bundle.main.path(forResource: "style", ofType: "css") {
        do {
            let contents = try String(contentsOfFile: filepath)
            html += contents
        } catch {
            // contents could not be loaded
        }
    }
    
    //html += ".chord {color: " + GetAccentColor() + "; }"
    //html += ".section.chorus {background-color: " + GetHighlightColor() + "; }"
    

    
    html += "</style>"
    
    html += """
            </style>
            </head>
            <body>
            <div id="container">
            """
    html += "<div id=\"header\">"
    if song.title != nil {
        html += "<h1 class=\"title\">" + song.title! + "</h1>"
    }

    if song.artist != nil {
        html += "<h2 class=\"artist\">" + song.artist! + "</h2>"
    }
    html += "</div>"
    html += "<div id=\"grid\">"
    song.sections.forEach { section in
        //html += "<div class=\"sections\">"
        html += SectionView(section)
        if !section.lines.isEmpty {
            html += "<div class=\"lines\">"
            section.lines.forEach { (line) in
                if !line.measures.isEmpty {
                    html += MeasuresView(line)
                } else if line.tablature != nil {
                    html += "<div class=\"tablature\">" +  line.tablature! + "</div>"
                } else if (section.type == nil) {
                    html += "<div class=\"plain\">"
                    html += PlainView(line)
                    html += "</div>"
                } else if line.comment != nil {
                    html += "<div class=\"comment\">" +  line.comment! + "</div>"
                } else {
                    html += PartsView(line)
                }
            }
            html += "</div>"
        }
        
        //html += "</div>"
    }
    html += "</div>"

    html += "</body></html>"

    return html
}

func SectionView(_ section: Section) -> String {
    var html = ""

    html += "<div class=\"section "
    if section.lines.isEmpty {
        html += "empty "
    }
    html += (section.type != nil ? section.type! : "")
    html += "\">"
    html += (section.name != nil ? section.name! : "&nbsp;")
    html += "</div>"
    
    return html
}

func MeasuresView(_ line: Line) -> String {
    //let measures = [Measure]()
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
