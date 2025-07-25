//
//  C64View+functions.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension C64View {

    // MARK: Functions

    func addOutput() async {

        if let song = appState.song {

            output = []

            var lineNumber = 100

            let lowerCharacters = Output(
                id: lineNumber,
                command: .poke,
                text: "",
                code: "\(lineNumber) poke 53272,23"
            )
            output.append(lowerCharacters)
            lineNumber += 10

            addLine("53280", command: .poke, color: .darkGray, lineNumber: &lineNumber)
            addLine("53281", command: .poke, color: .black, lineNumber: &lineNumber)
            addLine("chr$(147)", command: .clear, lineNumber: &lineNumber)

            for line in song.sections.flatMap(\.lines) {

                switch line.type {

                case .songLine:
                    switch line.context {
                    case .chorus, .verse, .bridge:
                        let parts = parseParts(parts: line.parts ?? [])

                        for content in parts {
                            addLine("\(content.chords)", color: .red, lineNumber: &lineNumber)
                            addLine("\(content.lyrics)", lineNumber: &lineNumber)
                        }
                    case .textblock:
                        let lines = line.source.split(by: 39)
                        for line in lines {
                            addLine("\(line)", color: .lightBlue, lineNumber: &lineNumber)
                        }
                    default:
                        addLine("\(line.source)", lineNumber: &lineNumber)
                    }
                case .emptyLine:
                    if line.context != .emptyLine {
                        addLine(" ", lineNumber: &lineNumber)
                    }
                case .metadata:
                    if line.directive != .define {
                        addLine("\(parseDirective(line))", color: .orange, lineNumber: &lineNumber)
                    }
                case .comment:
                    let lines = parseDirective(line).split(by: 39)
                    for line in lines {
                        addLine("\(line)", color: .yellow, lineNumber: &lineNumber)
                    }
                case .sourceComment:
                    addLine("\(line.source)", command: .rem, lineNumber: &lineNumber)
                case .environmentDirective:
                    if ChordPro.Directive.environmentDirectives.contains(line.directive ?? .unknown) {
                        addLine(" ", lineNumber: &lineNumber)
                        addLine("-- \(line.label) --", color: .green, lineNumber: &lineNumber)
                    }
                    addLine(" ", lineNumber: &lineNumber)
                case .unknown:
                    addLine("\(lineNumber) print \"\(line.source)\"", lineNumber: &lineNumber)
                }
            }
            endOfSong(lineNumber: &lineNumber)
        } else {
            output = []
            page = 0
            run = false
            runCounter = 0
        }
    }

    func checkScrollLine(lineNumber: inout Int) {
        let printOutput = output.filter { $0.command == .print }.count + 1
        if printOutput > 1, printOutput.isMultiple(of: 24) {
            /// Print the scroll text
            let page = printOutput / 24
            let scrollText = "-- Page \(page) - UP/DOWN to scroll --"
            addLine(scrollText, command: .scroller, color: .cyan, lineNumber: &lineNumber)
            let raw = "a = peek(197): if a=64 then \(lineNumber)"
            addLine(raw, command: .raw, lineNumber: &lineNumber)
            addLine("if a=7 then \(lineNumber + 20)", command: .ifThen, lineNumber: &lineNumber)
            addLine("\(lineNumber - 20)", command: .goto, lineNumber: &lineNumber)
            addLine("chr$(147)", command: .clear, lineNumber: &lineNumber)
        }
    }

    func endOfSong(lineNumber: inout Int) {
        let printOutput = output.filter { $0.command == .print }.count + 1
        /// Print the end of song text
        let page = (printOutput / 24) + 1
        let scrollText = "-- Page \(page) - UP/DOWN start SPACE stop --"
        addLine(scrollText, command: .scroller, color: .cyan, lineNumber: &lineNumber)
        let raw = "a = peek(197): if a=64 then \(lineNumber + 10)"
        addLine(raw, command: .raw, lineNumber: &lineNumber)
        addLine("if a=7 then 140", command: .ifThen, lineNumber: &lineNumber)
        addLine("if a=60 then \(lineNumber + 20)", command: .ifThen, lineNumber: &lineNumber)
        addLine("\(lineNumber - 30)", command: .goto, lineNumber: &lineNumber)
        addLine("chr$(147)", command: .clear, lineNumber: &lineNumber)
    }

    func addLine(_ content: String, command: Command = .print, color: C64Color? = nil, lineNumber: inout Int) {

        var code = ""
        var command: Command = command
        switch command {
        case .print:
            /// Check if we need a scroll- line first
            checkScrollLine(lineNumber: &lineNumber)
            code = "print \"\(content)\""
        case .poke:
            code = "poke \(content),\(color?.code ?? 0)"
        case .rem:
            let comment = content.dropFirst().trimmingCharacters(in: .whitespaces)
            code = "rem \(comment)"
        case .scroller:
            code = "print \"\(content)\""
            command = .print
        case .clear:
            code = "print \(content)"
        case .goto:
            code = "goto \(content)"
        case .ifThen, .raw:
            code = content
        }

        if let last = output.last, last.color != nil, color == nil {
            /// Set the default color
            let line = Output(
                id: lineNumber,
                command: .poke,
                text: content,
                code: "\(lineNumber) poke 646,1",
                color: color
            )
            output.append(line)
            lineNumber += 10
        }

        if command == .print, let color, let last = output.last, last.color != color {
            let line = Output(
                id: lineNumber,
                command: .poke,
                text: content,
                code: "\(lineNumber) poke 646,\(color.code)",
                color: color
            )
            output.append(line)
            lineNumber += 10
        }

        let line = Output(
            id: lineNumber,
            command: command,
            text: content,
            code: "\(lineNumber) \(code)",
            color: color
        )
        output.append(line)
        lineNumber += 10
    }

    func parseParts(parts: [Song.Section.Line.Part]) -> [(chords: String, lyrics: String)] {

        func addPart() {
            let strippedChords = chords.split(by: 39)
            let lines = lyrics.split(by: 39)
            result.append( (strippedChords.first ?? chords, lines.first ?? lyrics) )
            if lines.count > 1 {
                let remaining = lines.dropFirst()
                for line in remaining {
                    result.append((" ", String(line)))
                }
            }
        }

        var result = [(chords: String, lyrics: String)]()

        var chords: String = ""
        var lyrics: String = ""

        for part in parts {

            let characters = max((part.chordDefinition?.getName.count ?? -1) + 1, part.text?.count ?? 0) + lyrics.count
            /// A line can be max 39 characters long
            if characters >= 39 {
                addPart()
                chords = ""
                lyrics = ""
            }

            if let chord = part.chordDefinition {
                chords += "\(chord.getName) "
            }
            lyrics += part.text ?? ""
            let chordsLenght = chords.count
            let lyricsLenght = lyrics.count
            if chordsLenght > lyricsLenght {
                lyrics += String(repeating: " ", count: chordsLenght - lyricsLenght)
            } else if lyricsLenght > chordsLenght {
                chords += String(repeating: " ", count: lyricsLenght - chordsLenght)
            }
        }
        /// Append if we still have something left
        if !lyrics.isEmpty {
            addPart()
        }
        return result
    }


    func parseDirective(_ line: Song.Section.Line) -> String {
        "\(line.plain ?? "")"
    }

    func getPageContent() async {
        if !loadingPage {
            loadingPage = true
            pageContent = []
            let printOutput = output.filter { $0.command == .print }

            let maxLines = printOutput.count

            totalPages = Int(ceil(Double(maxLines) / 24))

            if (page + 1) > totalPages {
                page = 0
            }

            let startIndex = min(page * 24, max(maxLines - 24, maxLines))
            let endIndex = min(startIndex + 24, maxLines)
            let content = Array(printOutput[startIndex..<endIndex])

            do {
                for line in content {
                    try Task.checkCancellation()
                    pageContent.append(line)
                    try? await Task.sleep(for: .seconds(0.005))
                }
            } catch {
                pageContent = []
            }
            loadingPage = false
        }
    }
}
