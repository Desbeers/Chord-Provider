//
//  C64View.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` to show the song in Commodore 64 style
struct C64View: View {
    let lines: [Song.Section.Line]
    @State private var output: [Output] = []
    @State private var run: Bool = false
    /// The body of the `View`
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    Text("**** COMMODORE 64 BASIC V2 ****")
                    Text("64K RAM SYSTEM 38911 BASIC BYTES FREE")
                        .padding(.bottom)
                    VStack(alignment: .leading) {
                        ForEach(output) { line in
                            Text(line.code)
                        }
                        Text("READY.")
                            .padding(.top)
                        Image(systemName: "square.fill")
                            .symbolEffect(.pulse, options: .repeat(.continuous))
                    }
                }
                .padding()
                .background(C64Color.blue.swiftColor)
            }
            .font(.system(size: 18, weight: .semibold, design: .monospaced))
            Button {
                withAnimation {
                    run.toggle()
                }
            } label: {
                Text(run ? "Stop" : "Run")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(C64Color.lightBlue.swiftColor)
        .foregroundStyle(C64Color.lightBlue.swiftColor)
        .animation(.default, value: run)
        .task(id: lines) {
            addOutput()
        }
        .overlay {
            if run {
                RunSheet(output: $output)
            }
        }
    }

    // MARK: Functions

    func addOutput() {

        output = []

        var lineNumber = 100

        addLine("53280", command: .poke, color: .darkGray, lineNumber: &lineNumber)
        addLine("53281", command: .poke, color: .black, lineNumber: &lineNumber)
        addLine("646", command: .poke, color: .white, lineNumber: &lineNumber)

        for line in lines {

            switch line.type {

            case .songLine:
                switch line.context {
                case .chorus, .verse, .bridge:
                    let content = parsePart(parts: line.parts ?? [])
                    addLine("\(content.chords)", color: .red, lineNumber: &lineNumber)
                    addLine("\(content.lyrics)", lineNumber: &lineNumber)
                case .textblock:
                    addLine("\(line.source)", color: .lightBlue, lineNumber: &lineNumber)
                default:
                    addLine("\(line.source)", lineNumber: &lineNumber)
                }
            case .emptyLine:
                addLine("\(line.source)", lineNumber: &lineNumber)
            case .metadata:
                addLine("\(parseDirective(line))", color: .orange, lineNumber: &lineNumber)
            case .comment:
                addLine("\(parseDirective(line))", color: .yellow, lineNumber: &lineNumber)
            case .sourceComment:
                addLine("\(line.source)", command: .rem, lineNumber: &lineNumber)
            case .environmentDirective:
                if ChordPro.Directive.environmentDirectives.contains(line.directive ?? .unknown) {
                    addLine("-- \(line.directive?.details.label ?? line.source) --", color: .green, lineNumber: &lineNumber)
                }
            case .unknown:
                addLine("\(lineNumber) print \"\(line.source)\"", lineNumber: &lineNumber)
            }
        }
    }

    func addLine(_ content: String, command: Command = .print, color: C64Color? = nil, lineNumber: inout Int) {

        var code = ""
        switch command {
        case .print:
            code = "PRINT \"\(content)\""
        case .poke:
            code = "POKE \(content),\(color?.code ?? 0)"
        case .rem:
            let comment = content.dropFirst().trimmingCharacters(in: .whitespaces)
            code = "REM \(comment)"
        }

        if let last = output.last, last.color != nil, color == nil {
            /// Set the default color
            let line = Output(
                id: lineNumber,
                command: .poke,
                text: content,
                code: "\(lineNumber) POKE 646,1",
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
                code: "\(lineNumber) POKE 646,\(color.code)",
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

    func parsePart(parts: [Song.Section.Line.Part]) -> (chords: String, lyrics: String) {
        var chords: String = ""
        var lyrics: String = ""
        for part in parts {
            chords += part.chordDefinition?.getName ?? ""
            lyrics += part.text ?? ""
            let chordsLenght = chords.count
            let lyricsLenght = lyrics.count
            if chordsLenght > lyricsLenght {
                lyrics += String(repeating: " ", count: chordsLenght - lyricsLenght)
            } else if lyricsLenght > chordsLenght {
                chords += String(repeating: " ", count: lyricsLenght - chordsLenght)
            }
        }
        return (chords, lyrics)
    }

    func parseDirective(_ line: Song.Section.Line) -> String {
        "\(line.plain ?? "")"
    }

    // MARK: Structures

    struct Output: Identifiable {
        var id: Int
        var command: Command
        var text: String
        var code: String
        var color: C64Color?
    }

    enum Command {
        case print
        case poke
        case rem
    }

    enum C64Color: String {
        case black = "#000000"
        case white = "#ffffff"
        case red = "#df1a4d"
        case cyan = "#aaff66"
        case purple = "#b86fba"
        case green = "#00aa00"
        case blue = "#0000aa"
        case yellow = "#aaaa00"
        case orange = "#dd8855"
        case brown = "#6f4f25"
        case pink = "#ff7777"
        case darkGray = "#6c6c6c"
        case grey = "#9ad284"
        case lightGreen = "#5cab5e"
        case lightBlue = "#6c5eb5"
        case lightGrey = "#bcbcbc"

        var swiftColor: Color {
            Color(hex: self.rawValue) ?? Color.primary
        }

        var code: Int {
            switch self {
            case .black: 0
            case .white: 1
            case .red: 2
            case .cyan: 3
            case .purple: 4
            case .green: 5
            case .blue: 6
            case .yellow: 7
            case .orange: 8
            case .brown: 9
            case .pink: 10
            case .darkGray: 11
            case .grey: 12
            case .lightGreen: 13
            case .lightBlue: 14
            case .lightGrey: 15
            }
        }
    }
}

extension C64View {

    /// SwiftUI `View` running the Commodore 64 code
    struct RunSheet: View {
        /// The output
        @Binding var output: [Output]
        /// The body of the `View`
        var body: some View {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(output) {line in
                        if line.command == .print {
                            Text(line.text)
                                .foregroundStyle(line.color?.swiftColor ?? .white)
                        }
                    }
                }
                .background(C64Color.black.swiftColor)
            }
            .padding(40)
            .frame(width: 640, height: 480)
            .background(C64Color.darkGray.swiftColor.shadow(.drop(radius: 10)))
            .foregroundStyle(.white)
            .font(.system(size: 18, weight: .semibold, design: .monospaced))
        }
    }
}
